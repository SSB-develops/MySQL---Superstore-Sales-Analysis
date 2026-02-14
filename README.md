# 📊 Superstore Sales Analysis (SQL Project)

## 🧾 Project Overview
This project analyzes the **Global Superstore dataset** using SQL to evaluate sales performance, profitability, shipping efficiency, and customer behaviour across different markets and regions.

The objective was to simulate a real-world business scenario where a Data Analyst derives insights to support strategic decision-making.

---

## 🛠️ Tools & Technologies Used
- Excel
- MySQL
- SQL


---

## 📁 Dataset Information
- Dataset: Global Superstore Dataset (Superstore Sales Dataset)
- Source: Kaggle  
- Rows: ~50K  
- Columns: 21  

---

## 🧹 Data Preparation & Validation
Before analysis, the following steps were performed:

✔ Verified and standardized date formats  
✔ Checked for NULL values  
✔ Validated shipping date logic (Ship Date ≥ Order Date)  
✔ Ensured correct data types for numerical columns  

---

## 📈 Business Analysis Performed

### 🔹 Sales & Profit Analysis
- Total Sales & Total Profit
- Year-wise and Market-wise Sales Trends
- Profit Margin by Category

### 🔹 Market & Region Performance
- Sales by Market
- Top 5 Countries by Profit
- Most Profitable Categories

### 🔹 Discount Impact Analysis
- Profit comparison between discounted vs non-discounted orders
- Identification of loss-making products

### 🔹 Order & Shipping Analysis
- Average Delivery Time
- Shipping Cost by Ship Mode
- Order Priority Distribution

### 🔹 Customer & Product Insights
- High-Value Orders Identification
- Customer Segmentation (High / Medium / Low Value)
- Top 10 Products by Sales
- Top 3 Products per Market

---

## 🧠 Advanced SQL Concepts Used

✔ GROUP BY & HAVING  
✔ Aggregate Functions (SUM, AVG, COUNT)  
✔ CASE Statements  
✔ Window Functions:
   - RANK()  
   - DENSE_RANK()  
   - ROW_NUMBER()  
✔ Running Total using SUM() OVER()  
✔ PARTITION BY  

---

## 🏆 Key Insights Derived

- A small percentage of products contribute significantly to overall revenue.
- High discount rates negatively impact profit margins.
- Certain markets outperform others in both sales and profitability.
- Standard shipping mode accounts for the majority of orders.

---

