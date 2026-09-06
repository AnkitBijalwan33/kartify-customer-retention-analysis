-- Kartify E-Commerce: Cleaning check, business KPIs, and Customer Risk Score
-- Run after: USE ecommerce_db; and after the 4 compatibility views are created
-- (customers, orders, order_items, products -> mapped to the _clean / _raw tables)

USE ecommerce_db;

CREATE OR REPLACE VIEW customers AS SELECT * FROM customers_clean;
CREATE OR REPLACE VIEW orders AS SELECT * FROM orders_clean;
CREATE OR REPLACE VIEW order_items AS SELECT * FROM order_items_clean;
CREATE OR REPLACE VIEW products AS SELECT * FROM products_raw;


-- 1. Data quality check: duplicate orders and missing customer info
Select
    (Select Count(*) From orders Group by order_id Having Count(*) > 1) As duplicate_orders_flag,
    (Select Count(*) From customers Where city Is Null) As missing_city,
    (Select Count(*) From customers Where gender Is Null) As missing_gender,
    (Select Count(*) From order_items Where quantity <= 0) As invalid_quantity,
    (Select Count(*) From order_items Where unit_price <= 0) As invalid_price;


-- 2. Core KPIs: revenue, orders, AOV, cancellation rate
Select
    Sum(Case When o.order_status = 'Delivered' Then oi.quantity * oi.unit_price Else 0 End) As total_revenue,
    Count(Distinct Case When o.order_status = 'Delivered' Then o.order_id End) As delivered_orders,
    Sum(Case When o.order_status = 'Delivered' Then oi.quantity * oi.unit_price Else 0 End)
        / Count(Distinct Case When o.order_status = 'Delivered' Then o.order_id End) As avg_order_value,
    100.0 * Sum(Case When o.order_status = 'Cancelled' Then 1 Else 0 End) / Count(Distinct o.order_id) As cancellation_rate
From orders as o
Inner join order_items as oi On o.order_id = oi.order_id;


-- 3. Top 10 products by revenue 
Select p.product_name, p.category, Sum(oi.quantity * oi.unit_price) as total_revenue
From order_items as oi
Inner join orders as o On oi.order_id = o.order_id
Inner join products as p On oi.product_id = p.product_id
Where o.order_status = 'Delivered'
Group by p.product_name, p.category
Order by total_revenue desc
LIMIT 10;


-- 4. Revenue by category 
Select p.category, Sum(oi.quantity * oi.unit_price) as total_revenue
From order_items as oi
Inner join orders as o On oi.order_id = o.order_id
Inner join products as p On oi.product_id = p.product_id
Where o.order_status = 'Delivered'
Group by p.category
Order by total_revenue desc;


-- 5. Revenue by city 
Select c.city, Sum(oi.quantity * oi.unit_price) as total_revenue
From orders as o
Inner join order_items as oi On o.order_id = oi.order_id
Inner join customers as c On o.customer_id = c.customer_id
Where o.order_status = 'Delivered'
Group by c.city
Order by total_revenue desc;


-- 6. Repeat purchase rate 
With customer_orders As
(
    Select customer_id, Count(Distinct order_id) as order_count
    From orders
    Where order_status = 'Delivered'
    Group by customer_id
)
Select Count(*) As total_customers,
    Sum(Case When order_count > 1 Then 1 Else 0 End) As repeat_customers,
    Round(100.0 * Sum(Case When order_count > 1 Then 1 Else 0 End) / Count(*), 2) As repeat_purchase_rate
From customer_orders;


-- 7. Customer Risk view: the core rule behind Page 4
-- Recency = days since last Delivered order. Monetary = total spend on Delivered orders.
-- Built once as a view so every later query just reads from it instead of repeating the logic.
CREATE OR REPLACE VIEW customer_risk AS
With customer_activity As
( 
Select c.customer_id,
        Max(o.order_date) As last_order_date,
        Sum(oi.quantity * oi.unit_price) As total_spend,
        Count(Distinct o.order_id) As order_count
    From customers as c
    Left join orders as o On c.customer_id = o.customer_id And o.order_status = 'Delivered'
    Left join order_items as oi On o.order_id = oi.order_id
    Group by c.customer_id
)
Select 
    customer_id,
    total_spend,
    DATEDIFF((Select Max(order_date) From orders), last_order_date) As recency_days,
    Case
        When order_count = 0 Then 'Inactive - No Orders'
        When order_count = 1 Then 'Active - New'
        When DATEDIFF((Select Max(order_date) From orders), last_order_date) > 90
             And total_spend >= (Select Avg(total_spend) From customer_activity Where total_spend > 0)
             Then 'High Value - At Risk'
        When DATEDIFF((Select Max(order_date) From orders), last_order_date) > 90 Then 'Low Value - At Risk'
        Else 'Active - Repeat'
    End As risk_category
From customer_activity;

Select * From customer_risk;


-- 8. Revenue at Risk (Page 4 flagship number) - just reads the view, no repeated logic
Select
    Count(*) As high_risk_customers,
    Sum(total_spend) As revenue_at_risk
From customer_risk
Where risk_category = 'High Value - At Risk';


-- 9. Cancellation revenue by city and category (Page 4)
Select c.city, p.category, Sum(oi.quantity * oi.unit_price) as cancelled_revenue
From orders as o
Inner join order_items as oi On o.order_id = oi.order_id
Inner join customers as c On o.customer_id = c.customer_id
Inner join products as p On oi.product_id = p.product_id
Where o.order_status = 'Cancelled'
Group by c.city, p.category
Order by cancelled_revenue desc;


-- 10. Monthly revenue trend with running total (Page 1 line chart)
With monthly_revenue As
(
    Select DATE_FORMAT(o.order_date, '%Y-%m-01') as month_start,
           Sum(oi.quantity * oi.unit_price) as revenue
    From orders as o
    Inner join order_items as oi On o.order_id = oi.order_id
    Where o.order_status = 'Delivered'
    Group by DATE_FORMAT(o.order_date, '%Y-%m-01')
)
Select month_start, revenue,
       Sum(revenue) Over(Order by month_start Rows Between Unbounded Preceding And Current Row) As running_revenue
From monthly_revenue
Order by month_start;


-- 11. Top 3 products per category (shows window functions beyond simple ranking)
With product_revenue As
(
    Select p.product_name, p.category, Sum(oi.quantity * oi.unit_price) as total_revenue
    From order_items as oi
    Inner join orders as o On oi.order_id = o.order_id
    Inner join products as p On oi.product_id = p.product_id
    Where o.order_status = 'Delivered'
    Group by p.product_name, p.category
)
Select category, product_name, total_revenue, product_rank
From
(
    Select *, Row_Number() Over(Partition by category Order by total_revenue desc) as product_rank
    From product_revenue
) as ranked
Where product_rank <= 3
Order by category, product_rank;


-- 12. Cohort base table (feeds the retention analysis in the Python notebook)
Select o.customer_id, o.order_id, o.order_date, o.order_status
From orders as o
Where o.order_status = 'Delivered'
Order by o.customer_id, o.order_date;
