# 🛒 Customer Retention & Revenue Leakage Analysis — Kartify E-Commerce

An end-to-end E-Commerce analytics project built to identify at-risk customers and quantify revenue leakage for **Kartify**, a multi-category online retailer — using Python, SQL, and Power BI, with a custom rule-based Customer Risk Score as the centerpiece.

---

## 📌 Short Description / Purpose

This project analyzes orders across 1,000 customers on a multi-category e-commerce platform (Electronics, Fashion, Beauty, Furniture, Home, Sports) to answer a question every retail business asks: *where are we losing customers, and how much revenue does it actually cost us?* The pipeline cleans the raw data in SQL, builds a rule-based Customer Risk Score and Revenue-at-Risk metric, runs cohort retention analysis in Python, and surfaces everything through a 5-page interactive Power BI dashboard.

---

## 🛠️ Tech Stack

- 🗄️ **MySQL Workbench** – Data cleaning (duplicates, missing values, invalid records), a rule-based Customer Risk view, and business-question queries using CTEs and window functions
- 🐍 **Python (Pandas, SQLAlchemy, Seaborn, Matplotlib)** – Pulling cleaned tables from MySQL, cohort retention analysis, and EDA
- 📊 **Power BI Desktop** – 5-page interactive dashboard and visualization platform
- 🧠 **DAX (Data Analysis Expressions)** – Revenue-at-Risk and Cancelled Revenue measures, risk-category KPIs
- 📁 **File Format** – `.sql` for queries, `.ipynb` for analysis, `.png` for dashboard previews

---

## 📂 Data Source

An internal-style e-commerce dataset consisting of 4 linked tables — `customers`, `orders`, `order_items`, and `products` — spanning 6 product categories and several major Indian cities, with order activity from January 2025 to June 2026. The raw data included realistic data-quality issues (missing values, duplicate orders, inconsistent city casing, invalid quantities/prices, and orphan records), which were cleaned in SQL before analysis.

---

## ✨ Features / Highlights

### 🎯 Business Problem

Kartify's leadership has one recurring question every retail company asks: **"We're losing customers — where exactly, and how much revenue are we leaking?"** The company had raw transaction data but no clear, quantified answer to:
- Which customers are quietly churning, and what is that costing us in ₹?
- Where in the customer journey do we lose the most people?
- Which cities and categories are driving cancellation losses?

### 🎯 Goal of the Dashboard

To deliver a 5-page interactive Power BI report that:
- Tracks overall sales performance and customer behavior end-to-end
- Segments customers using a transparent, rule-based Risk Score (no ML required)
- Converts churn risk into a hard ₹ number leadership can act on
- Pinpoints exactly where cancellations are draining revenue

### 🖥️ Walkthrough of Key Visuals

**Page 1 — Executive Sales Dashboard**
- KPI cards: Total Revenue (₹159.54M), Delivered Orders (4K), Total Customers (1K), Average Order Value (₹39.65K), Cancellation Rate (7.25%)
- Bar charts: Top 10 Products by Revenue, Revenue by Category, Revenue by City
- Line chart: Monthly Revenue Trend (Jan 2025 – Jun 2026)

**Page 2 — Customer Analysis**
- KPI cards: Total Customers (1K), Repeat Customers (835), Repeat Purchase Rate (86.98%), Average Customer Revenue (₹166.89K)
- Combo chart: New vs. Returning Customers by month
- Bar charts: Top 10 Customers by Revenue, Revenue by Gender
- Distribution chart: Customer Purchase Frequency — most customers order a handful of times before frequency tapers off

**Page 3 — Product & Category Analysis**
- KPI cards: Total Quantity Sold (10K), Best-Selling Product (Laptop 2), Best Category (Electronics)
- Bar charts: Top 10 Products by Revenue and by Quantity Sold
- Donut chart: Category Revenue Contribution % — Electronics alone drives 77.42%
- Stacked column: Monthly Revenue by Category

**Page 4 — Revenue at Risk & Cancellation Impact** *(flagship page)*
- KPI cards: **Revenue at Risk (₹54.78M / ~₹5.48 Cr)**, High-Risk Customers (333), Cancelled Revenue (₹17.43M / ~₹1.74 Cr)
- Bar chart: Revenue by Customer Risk Category (Active–Repeat, High Value–At Risk, Low Value–At Risk, Active–New)
- Bar chart: Cancellation Revenue by City — Delhi leads
- Donut chart: Cancellation Revenue by Category — Electronics accounts for 76.27%
- Bar chart: Recency vs. Spend by Risk Category

**Page 5 — Key Insights & Recommendations**
- A summary page translating every chart into a plain-language business recommendation, checked against the underlying numbers

### 💡 Business Impact & Insights

- **Revenue-at-Risk quantification:** 333 customers who were previously high-value spenders have gone inactive for 90+ days, putting roughly **₹5.48 Cr** of historical revenue at risk — a single number that reframes "churn" as a budget line item, not just a percentage.
- **The 30-day cliff:** Cohort retention analysis shows the steepest customer drop-off happens within the first 30 days of a first purchase, after which retention stabilizes. This points to a specific, fixable intervention window (a Day-15 follow-up offer) rather than a vague "improve retention" goal.
- **Cancellation is concentrated, not spread out:** Electronics drives over three-quarters of all cancelled revenue, and a single city accounts for the largest share of cancellations — a combination worth auditing (delivery timelines, product expectations) before any other city or category.
- **Retention beats acquisition, for now:** The Active–Repeat segment generates roughly double the revenue of the At-Risk segment, meaning retention campaigns will likely protect more revenue than new-customer acquisition spend in the short term.
- **Rule-based scoring works without ML:** A Recency + Monetary threshold rule, built once as a SQL view and reused everywhere it's needed, was enough to cleanly separate customers into actionable segments — showing that explainable business logic can substitute for a full ML pipeline at this stage.

---

## 📸 Screenshots / Demos

| Page | Preview |
|---|---|
| Executive Sales Dashboard | `Ecommerce_Dashboard_Screenshots/page1_executive_sales_dashboard.png` |
| Customer Analysis | `Ecommerce_Dashboard_Screenshots/page2_Customer_Analysis.png` |
| Product & Category Analysis | `Ecommerce_Dashboard_Screenshots/page3_product_category_analysis.png` |
| Revenue at Risk & Cancellation Impact | `Ecommerce_Dashboard_Screenshots/page4_revenue_at_risk_cancellation.png` |
| Key Insights & Recommendations | `Ecommerce_Dashboard_Screenshots/page5_key_insights_recommendations.png` |

🎥 **Watch the interactive dashboard demo (with live slicer filtering):** [LinkedIn Post Link]

*Note: The Power BI file (.pbix) is not included in this repository, to protect the dashboard design and DAX logic. Screenshots and a video walkthrough are provided instead — feel free to reach out if you'd like to discuss the implementation.*

---

## 📁 Repository Structure

```
ecommerce-customer-retention-analysis/
├── README.md
├── Ecommerce_SQL_Cleaning_RiskScoring.sql
├── Ecommerce_EDA_Cohort_Analysis.ipynb
└── Ecommerce_Dashboard_Screenshots/
    ├── page1_executive_sales_dashboard.png
    ├── page2_customer_analysis.png
    ├── page3_product_category_analysis.png
    ├── page4_revenue_at_risk_cancellation.png
    └── page5_key_insights_recommendations.png
```

---

## 🔗 Connect

**Ankit Bijalwan**
If you're working in E-Commerce / retail analytics and have feedback on this project, I'd love to hear it — feel free to reach out on [LinkedIn](https://www.linkedin.com/in/bijalwanankit).
