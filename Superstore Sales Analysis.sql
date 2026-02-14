/* =====================================================
   SUPERSTORE SALES ANALYSIS PROJECT
   Author: Sandhya Budhavale
   Tool: MySQL
===================================================== */

/* ===============================
   1. DATABASE & TABLE CREATION
================================= */

-- Database
CREATE DATABASE superstore_project;

-- Using db 
USE superstore_project;

-- Superstore table 
DROP TABLE IF EXISTS superstore;

CREATE TABLE superstore (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    state VARCHAR(100),
    country VARCHAR(100),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales INT,
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    order_priority VARCHAR(50),
    year INT
);

select * from superstore;
select count(*) from superstore; -- 51290 

/* ===============================
   2. DATA CLEANING & VALIDATION
================================= */

-- Checking for null values 
SELECT COUNT(*) FROM superstore WHERE sales IS NULL;
SELECT COUNT(*) FROM superstore WHERE profit IS NULL;
SELECT COUNT(*) FROM superstore WHERE order_date IS NULL;
SELECT COUNT(*) FROM superstore WHERE ship_date IS NULL;
SELECT COUNT(*) FROM superstore WHERE customer_name IS NULL;
SELECT COUNT(*) FROM superstore WHERE product_name IS NULL;

-- Check for Negative or Invalid Values
SELECT * FROM superstore WHERE sales < 0; 
SELECT * FROM superstore WHERE discount > 1;
SELECT order_id, product_id, COUNT(*) FROM superstore GROUP BY order_id, product_id HAVING COUNT(*) > 1;

-- Delivery Date Issues 
SELECT * FROM superstore WHERE ship_date < order_date;

/* ===============================
   3. BASIC ANALYSIS
================================= */

-- Total Sales & Total Profit
SELECT 
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore;

-- Total Unique Orders
SELECT COUNT(DISTINCT order_id) AS total_unique_orders FROM superstore; 

-- Sales by Market
SELECT market, SUM(sales) AS total_sales FROM superstore 
GROUP BY market ORDER BY total_sales DESC;

-- Top 10 Products by Sales 
SELECT product_name, SUM(sales) AS total_sales FROM superstore 
GROUP BY product_name ORDER BY total_sales DESC LIMIT 10;

-- Orders by Order Priority
SELECT order_priority, COUNT(DISTINCT order_id) AS total_order_count FROM superstore
GROUP BY order_priority
ORDER BY total_order_count DESC;

/* ===============================
   4. INTERMEDIATE ANALYSIS
================================= */

-- Total sales by year
SELECT year, SUM(sales) AS total_sales FROM superstore 
GROUP BY year
ORDER BY year ASC;

-- Profit margin % per category
SELECT category, ROUND((SUM(profit)/SUM(sales)) * 100, 2) AS profit_margin FROM superstore 
GROUP BY category
ORDER BY profit_margin DESC; 

-- Products where total profit is negative
SELECT product_name, SUM(profit) AS total_profit FROM superstore 
GROUP BY product_name
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- Top 5 countries based on total profit
SELECT country, SUM(profit) AS total_profit FROM superstore
GROUP BY country
ORDER BY total_profit DESC
LIMIT 5;
 
-- Average shipping cost per ship_mode
SELECT ship_mode, ROUND(AVG(shipping_cost), 2) AS ship_cost FROM superstore
GROUP BY ship_mode
ORDER BY ship_cost DESC;  

-- Orders where total sales per order > 2000
SELECT order_id, ROUND(SUM(sales),2) AS total_sales FROM superstore 
GROUP BY order_id
HAVING total_sales > 2000
ORDER BY total_sales DESC;

-- Discount Effect on Profit 
SELECT discount_type, ROUND(AVG(profit), 2) AS avg_profit 
FROM (
	SELECT profit,
		CASE 
			WHEN discount = 0 THEN "no discount"
			ELSE "with discount"
		END AS discount_type
	FROM superstore  
    ) t
GROUP BY discount_type
ORDER BY avg_profit DESC ;

/* ===============================
   5. ADVANCED ANALYSIS
================================= */

-- Rank products by total sales
SELECT product_name, SUM(sales) AS total_sales,
RANK() OVER(ORDER BY SUM(sales) DESC) AS rank_num
FROM superstore
GROUP BY product_name;  

-- Dense Rank by Profit Within Category 
SELECT 
    product_name,
    category,
    total_profit,
    DENSE_RANK() OVER (
        PARTITION BY category 
        ORDER BY total_profit DESC
    ) AS dense_rank_num
FROM (
    SELECT 
        product_name,
        category,
        SUM(profit) AS total_profit
    FROM superstore
    GROUP BY product_name, category
) t;

-- Row Number for Orders by Date
SELECT 
    order_id,
    order_date,
    ROW_NUMBER() OVER (ORDER BY order_date) AS row_num
FROM (
    SELECT DISTINCT order_id, order_date
    FROM superstore
) t;

-- Top 3 products by sales within each market
SELECT product_name, market, total_sales, rank_num
FROM (
    SELECT 
        product_name,
        market,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER(PARTITION BY market ORDER BY SUM(sales) DESC) AS rank_num
    FROM superstore
    GROUP BY product_name, market
) t
WHERE rank_num <= 3
ORDER BY market, rank_num;

-- Cumulative sales ordered by year.
SELECT 
    year,
    total_sales,
    SUM(total_sales) OVER (ORDER BY year) AS running_total
FROM (
    SELECT 
        year,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY year
) t
ORDER BY year;

-- Most profitable product inside each category
SELECT *
FROM (
    SELECT 
        product_name,
        category,
        SUM(profit) AS total_profit,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY SUM(profit) DESC
        ) AS rn
    FROM superstore
    GROUP BY product_name, category
) t
WHERE rn = 1;

-- Average delivery time (ship_date - order_date)
SELECT 
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 2) AS avg_delivery_days
FROM superstore;

-- Customer Classification
SELECT 
    customer_name,
    total_sales,
    CASE 
        WHEN total_sales > 5000 THEN 'High Value'
        WHEN total_sales BETWEEN 2000 AND 5000 THEN 'Medium'
        ELSE 'Low'
    END AS customer_category
FROM (
    SELECT 
        customer_name,
        SUM(sales) AS total_sales
    FROM superstore
    GROUP BY customer_name
) t
ORDER BY total_sales DESC;
 
    

 
        


