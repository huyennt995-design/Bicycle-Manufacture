# AdventureWorks Data Analysis (SQL Project) - Bicycle Manufacture

### 📌 Quick Navigation
* [1. Sales Performance](#1-sales--growth-performance)
* [2. Marketing & Customer Insights](#2-marketing--customer-insights)
* [3. Supply Chain & Inventory Operations](#3-supply-chain--inventory-operations)
* [4. Procurement & Financial Status](#4-procurement--financial-status)
* [5. Final Conclusion](#-final-project-conclusion)

## 📝 Executive Summary

This project focuses on extracting actionable business insights from the **AdventureWorks2019** dataset using **Google BigQuery,** representing a global **bicycle manufacturing** operation.

The analysis spans across **Sales, Production, and Purchasing** departments to evaluate revenue growth, customer behavior, and supply chain efficiency.

## 🛠 Tech Stack & Skills

- **Platform:** Google BigQuery (Standard SQL)
- **Advanced SQL Techniques:**
    - **CTEs:** For modular and readable code.
    - **Window Functions:** `DENSE_RANK`, `LAG/LEAD` for trend and growth analysis.
    - **Cohort Analysis:** To track customer retention over time.
    - **Data Transformation:** Handling data types (`CAST`, `FORMAT_DATETIME`) and cleaning (`NULLIF`, `COALESCE`).
      
 ## 🛠 Data Relationship Mapping
Below is the detailed mapping of relationships between Fact and Dimension tables used in this project.

<details>
  <summary><b>▶ Click to expand: Table Join Details</b></summary>

| Business Area | Fact Table (Linked From / FK) | Dimension Table (Linked to / PK) | Join Key | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Sales** | `Sales.SalesOrderDetail` | `Production.Product` | `ProductID` | Get product names and prices for sales reports. |
| **Sales** | `Sales.SalesOrderDetail` | `Sales.SalesOrderHeader` | `SalesOrderID` | Link line items to order-level details (Date, Total). |
| **Sales** | `Sales.SalesOrderDetail` | `Sales.SpecialOfferProduct` | `SpecialOfferID`, `ProductID` | Identify promotions applied to specific items. |
| **Sales** | `Sales.SalesOrderHeader` | `Sales.SalesTerritory` | `TerritoryID` | Analyze sales performance by geographic region. |
| **Marketing** | `Sales.SpecialOfferProduct`| `Sales.SpecialOffer` | `SpecialOfferID` | Retrieve details of specific discounts/promotions. |
| **Marketing** | `Sales.SpecialOfferProduct`| `Production.Product` | `ProductID` | List products included in special offers. |
| **Purchasing** | `Purchasing.PurchaseOrderDetail`| `Production.Product` | `ProductID` | Link vendor orders to specific product items. |
| **Purchasing** | `Purchasing.PurchaseOrderDetail`| `Purchasing.PurchaseOrderHeader`| `PurchaseOrderID` | Connect order lines to main purchase header. |
| **Production** | `Production.Product` | `Production.ProductSubcategory`| `ProductSubcategoryID` | Group products into sub-categories. |
| **Production** | `Production.ProductSubcategory`| `Production.ProductCategory` | `ProductCategoryID` | Roll up sub-categories into main categories. |
| **Production** | `Production.WorkOrder` | `Production.Product` | `ProductID` | Track manufacturing progress for products. |
| **Inventory** | `Production.ProductInventory` | `Production.Product` | `ProductID` | Monitor stock levels and storage locations. |

</details>

## 🚀**Project Key Highlights**

| **ID** | **Business Question** | **Key Metrics** | **SQL Techniques Used** | **Complexity** |
| --- | --- | --- | --- | --- |
| **Q1** | Sales Performance (L12M) | Revenue, Order Qty, Item Count | `DATE_TRUNC`, `FORMAT_DATETIME`, `Subquery` | ⭐⭐ |
| **Q2** | YoY Growth Analysis | **YoY Growth Rate (%)** | `LAG()`, `DENSE_RANK()`, `CTEs` | ⭐⭐ |
| **Q3** | Regional Market Share | Total Orders by Territory | `Multiple Joins`, `DENSE_RANK()` | ⭐ |
| **Q4** | Promotion Costing | **Total Discount Cost** | `LOWER()`, `LIKE`, `Aggregations` | ⭐ |
| **Q5** | Customer Retention | **Retention Rate (Cohort)** | `MIN() OVER()`, `Time-Series Modeling` | ⭐⭐⭐ |
| **Q6** | Inventory Fluctuation | **MoM Stock Diff (%)** | `LEAD()`, `NULLIF()`, `Window Functions` | ⭐⭐ |
| **Q7** | Operational Efficiency | **Stock-to-Sales Ratio** | `COALESCE()`, `NULLIF()`, `Cross-schema Join` | ⭐⭐ |
| **Q8** | Cash Flow Forecasting | Pending Order Value | `EXTRACT`, `Status Filtering` | ⭐ |


## 🔍 **Deep Dive: Understanding the Business Model**

AdventureWorks is a complex manufacturing company. To analyze this dataset deeply, I had to navigate three distinct business flows:

- **Sales to Production:** Connecting customer demand (`SalesOrderDetail`) to manufacturing output (`WorkOrder`).
- **Promotion Logic:** Identifying how `SpecialOffers` (Seasonal Discounts) impact the bottom line.
- **Supply Chain:** Monitoring the lag between `Pending` purchase orders and stock availability.

## 🔍 **8 Strategic Queries**

### 1. Sales & Growth Performance

**📊 Query 1 (L12M Performance):** Calculates total items sold, sales value, and order frequency per subcategory for the Last 12 Months.

**💡 Insight:** Identifying the "Revenue Drivers." This query highlights which subcategories contribute the most to the bottom line.

![image.png](attachment:8c16f559-3336-4344-bed5-1f94395dfce5:image.png)

**Query results:**

![image.png](attachment:ed6783aa-72c1-4cab-9e5f-2fe8e2310e36:image.png)

#### 💡 **Business Insights & Actions:**

- **High-Value Focus: ‘Mountain Bikes’** contribute nearly 90% of total revenue despite lower order volumn. **Action**: Invest in premium category for this category.
- **Cross-sell Oppotunity**: ‘**Helmets’** and ‘**Jerseys’** have high transaction frequency. **Action**: Bundle these as ‘Safety Kits’ with every bike purchase.
- **Inventory Optimization:**  **‘Locks’** show only near-zero demand. **Action**: Check stock levels and sell in bundles or reduce price to free up capital.

---

**📈 Query 2 (YoY Growth):** Analyzes Year-over-Year growth rates and identifies the **Top 3 fastest-growing subcategories** using `DENSE_RANK`.

💡 **Insight**: Identifying growth momentum helps the production team prioritize high-demand bike models.

![image.png](attachment:1c4e7ff7-d367-4093-b4b9-27fee42f7d39:image.png)

**Query results:**

![image.png](attachment:ec681a12-b3b8-4b40-afa9-f67312aa81bb:image.png)

#### 💡 **Business Insights & Actions:**

Theses 3 items have seen massive jumps in sales compared to last year (alle exceeding the 3x growth). **Action**: Increase marketing budget for these categories to maximize the profits.

---


**🗺️ Query 3 (Regional Ranking):** Ranks the Top 3 territories by order volume for each year to **identify high-performing markets**.

![image.png](attachment:dbe81e87-c003-4b71-80f9-0a87f24ae098:image.png)

**Query results:**

![image.png](attachment:dc343493-e58c-49f9-bc27-dda07035e100:image.png)

#### 💡 **Business Insights & Actions:**

All these territories listed have seen massive increases in order volumns between 2011 and 2013.

**Note:** There is a noticeable dip in 2014 data (which may represent partial-year results), but the overall multi-year trend shows explosive growth.

**Action**: Should proritize marketing budget here. Focusing advertising on Territory 4 and 6 specifically will help maintain this strong momentum and capture even more market share.

---

### 2. Marketing & Customer Insights

**🏷️ Query 4 (Promotion Impact):** Quantifies the total cost of discounts specifically for "Seasonal Discount" campaigns.

💡 **Insight**: Understanding the total cost of discounts reveals the **true profitability** of seasonal sales.

![image.png](attachment:70ed4644-439c-4813-b1b6-bf06e9a9024d:image.png)

**Query results:**

![image.png](attachment:9a231cec-437e-480f-abfe-8d3e9502f6f6:image.png)

#### 💡 **Business Insights & Actions:**

The cost of seasonal discounts for Helmets has nearly doubled. This indicates that the promotin is reaching significantly more customers or the discount hat increased, which could impact the overall profit margin for this category.

**Action:** 

- **Review profits**: Make sure the helmet sales are making up for the money we are ‘giving away’ through larger discounts.
- **Budget Adjustment**: Use theses numbers to set a strict ‘discount budget’ for next year, so we don’t accidentally cut too deep into our earnings.

---

**👥 Query 5 (Retention/Cohort Analysis):** Measures the **Customer Retention Rate** for 2014, tracking month-by-month activity from the initial join date (M-0, M-1, etc.).

**💡 Insight:** Track how many customers return month-over-month.

- **Step 1:** Filtered for `Status = 5` (Shipped) to ensure analysis on realized revenue.
- **Step 2:** Define the "Anchor Month" for each user.
    
    Used `MIN() OVER()` to pinpoint each customer's first purchase month.
    
- **Step 3**: **Retention Tracking —** Calculate the lapse time between orders.

![image.png](attachment:c1ed8986-49b7-475b-acca-0032b446b5ec:image.png)

**Query results:**

The Breakdown:

- **Month_join**: The month the customers first signed up (Month 1, 2, or 3).
- **month_diff**: How many months have passed since they joined (M-0 is their first month, M-1 is the next month, etc.).
- **cnt_customer**: How many customers are still active.

![image.png](attachment:40a6f355-5027-4e81-9334-f51e16630a5d:image.png)

#### 💡 Business Insights & Actions:

- We are losing a huge number of customers after their first month → Most customers are ‘one-time buyers’ and aren’t sticking around.

**Action:** After 30 days after their first purchase we should send a “Welcome Back” discount to encourage a second visit. 

- Noticed that a good number of customers suddenly return 3 months later. These customers might be coming back to refill a supply or buy something new for the start of a new season.

**Action:**  Run a specific marketing campaign at the 90-day mark to make sure even more people come back (e.g: send a friendly “We miss you” email or special offer).

[Back to top](#-8-strategic-queries)
---

### 3. Supply Chain & Inventory Operations

**📦 Query 6 (Stock Trends):** Tracks monthly stock levels and **MoM (Month-over-Month)** fluctuation percentages to monitor production stability.

![image.png](attachment:7127aca4-5a7c-40b6-bc07-6719eb322e48:image.png)

**Query results:**

![image.png](attachment:e392a549-70f0-4635-b19c-2c3f3dd8536f:image.png)

#### 💡 Business Insights & Actions:

**“BB Ball Bearing”** and **“Blade”:** Stock dropped by over 40% in December. While there was big inventory refills in October, these supplies were used up quickly by November and December.

🚀 **Strategic Action**

- **Improve Supply Timing**: Because stock levels drop significantly in November and December, you should plan larger inventory refills earlier in the year to prevent running out during the busy holiday period.
- **Proactive Stock Review**: These negative numbers indicate that inventory is being consumed at a very high rate. We should adjust purchase orders before inventory hits a critical low.

---

**⚖️ Query 7 (Stock-to-Sales Ratio):** Calculates the ratio between stock availability and actual sales per product, helping to identify overstock or stockout risks.

![image.png](attachment:2ec71852-8e98-4813-8507-db138a83dfbe:image.png)

**Query results:**

![image.png](attachment:0af9f4db-a331-4e62-ba30-e4fbad5cd0fd:image.png)

#### 💡 Business Insights & Actions:

- **Stagnant Inventory:** Item like HL Mountain Frame (Black, 48 & 42) have a stock-to-sales ratio of 27.0, meaning you have way more you need — the worst performance.
- **Popular items:** LL Road Frame - Red (44 & 60) are selling much better, with 10 - 12 sales each.

🚀 **Strategic Action**

- **Launc**h a specific “Year-End Clearance” or **marketing strategy** to clear the near-zero demand stock.
- **Adjust Inventory to Favorite Colors**: Shift your budget and warehouse space to favorite colors and models that have higher demand to ensure you don’t run out of what customers actually want to buy.

[⬆ Back to top](#8-strategic-queries)

---

### 4. Procurement & Financial Status

**💰 Query 8 (Pending Orders):** Monitors the volume and total value of purchase orders in "Pending" status for 2014 to assist in cash flow forecasting.

![image.png](attachment:452b50eb-87cb-4640-b085-91f93d7318d0:image.png)

**Query results:**

![image.png](attachment:babf256d-f0e9-4145-a3df-391184c0471c:image.png)

#### 💡 Business Insights & Actions:

$3.87 million in pending status is a huge amount of capital and potential inventory that is “frozen”. If these orders aren’t processed, it could be lead to dealys in production.

🚀 **Strategic Action**

- **Investigate the Bottleneck**: Why haven’t these 224 orders been approved yet? We should check If it’s due to lack of approval personal, system erros or issues with suppliers.
- **Prioritize high-value orders:** Filter out the highest-value orders in this list and process them first. This will free up cash flow und ensure the fastest possible supply chain for production.

---

## 🏁 Final Project Conclusion

This project demonstrates how data analysis can improve a bicycle manufacturing business. By using SQL to connect Sales, Production and Purchasing data, I found three main areas to improve:

- **Profit Growth**: Nearly 90% of revenue comes from Mountains Bike. The comany should focus marketing on this category.
- **Customer Loyalty**: The Cohort Analysis shows exactly when the customers stop buying (churn). This allows the marketing team to send targeted discounts or loyalty reward at a the right time to encourage the repeat purchases.
- **Inventory Efficiency**: By tracking the Stock-to-Sales ration, we can foucs on colors and models that customers actually want. Additionally, we should remove products with near-zero demand to free up capital and warehouse space for faster-moving goods.

[⬆ Back to top](#8-strategic-queries)
