/*
Project Name: Toys Sales Analysis
Author: Chetan Sharma
Created On: Jan 2026 - Feb 2026
Description:
This SQL script analyzes toy sales data to identify:
- Total revenue
- Top-selling products
- Sales trends by product_category, store_city, and store_location

Database: postgresql
*/

--Create Table toys_products:
DROP TABLE IF EXISTS toys_products;
CREATE TABLE toys_products(
				  Product_ID INT PRIMARY KEY,
				  Product_Name VARCHAR(50),	
				  Product_Category VARCHAR(50),
				  Product_Cost FLOAT,
				  Product_Price FLOAT
);
SELECT * FROM toys_products;

--Create Table toys_stores:
DROP TABLE IF EXISTS toys_stores;
CREATE TABLE toys_stores(
			      Store_ID INT PRIMARY KEY,
				  Store_Name VARCHAR(100),
				  Store_City VARCHAR(50),
				  Store_Location TEXT,
				  Store_Open_Date DATE
);
SELECT * FROM toys_stores;

--Create Table toys_inventory:
DROP TABLE IF EXISTS toys_inventory;
CREATE TABLE toys_inventory(
				  Store_ID INT REFERENCES toys_stores(Store_ID),
				  Product_ID INT REFERENCES toys_products(Product_ID),
				  Stock_On_Hand INT
);
SELECT * FROM toys_inventory;

--Create Table toys_sales:
DROP TABLE IF EXISTS toys_sales;
CREATE TABLE toys_sales(
				  Sale_ID INT PRIMARY KEY,
				  Transaction_Date DATE,
				  Store_ID INT REFERENCES toys_stores(Store_ID),
				  Product_ID INT REFERENCES toys_products(Product_ID),
				  Units_Sold INT
);
SELECT * FROM toys_sales;

--Create Table calendar:
DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar(
			      calendar_date DATE PRIMARY KEY
);
SELECT * FROM calendar;


SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;

--🟢BASIC SQL QUESTIONS (Foundations):

--1. Data Exploration:

--1. Show All Products In The Products Table.
SELECT product_name
FROM toys_products;

--2. List All Distinct Product Categories.
SELECT DISTINCT(product_category)
FROM toys_products;

--3. Find All Stores Located In Guadalajara.
SELECT store_name, store_city
FROM toys_stores
WHERE store_city = 'Guadalajara';

--4. Display The First 10 Rows From The Sales Table.
SELECT * FROM toys_sales
LIMIT 10;

--5. Count How Many Products Exist In Each Category.
SELECT product_category, COUNT(product_id) AS Total_Products
FROM toys_products
GROUP BY product_category
ORDER BY Total_Products DESC;

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;

--2.Filtering & Sorting:

--6. Find Products With a Price Greater Than 20.
SELECT product_id, product_name, product_price
	FROM toys_products
WHERE product_price > 20;

--7. Show Stores Opened After 2000.
SELECT
    store_id,
    store_name,
    store_open_date
FROM toys_stores
WHERE store_open_date >= DATE '2001-01-01';

--8. List Sales That Happened On 2022-01-01.
SELECT sale_id, units_sold, transaction_date
	FROM toys_sales
	WHERE transaction_date = '01-01-2022';
	
--9. Sort Products By Price Descending.
SELECT product_name, 
	   product_price
	FROM toys_products
ORDER BY product_price DESC;

--10. Find Inventory Records Where Stock_On_Hand = 0.
SELECT store_id, stock_on_hand
		FROM toys_inventory
	WHERE stock_on_hand = 0;
	
SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--3.Aggregations:

--11. Count Total Number Of Sales Transactions.
SELECT COUNT(sale_id) AS Total_Sales_Transaction
	FROM toys_sales;
	
--12. Find Total Units Sold Across All Sales.
SELECT sale_id, SUM(units_sold) AS Total_Units_Sold
	FROM toys_sales
  GROUP BY sale_id;
 
--13. Calculate Average Product Price Per Category.
SELECT product_category,
       ROUND(AVG(product_price)::numeric, 2) AS avg_product_price
FROM toys_products
GROUP BY product_category
ORDER BY avg_product_price DESC;

--14. Find The Minimum And Maximum Product Cost.
SELECT MIN(product_cost) AS Minimum_Cost,
	   MAX(product_cost) AS Maximum_Cost
	 FROM toys_products;
	 
--15. Count How Many Stores Exist Per City.
SELECT store_city,
		COUNT(store_id) AS Total_Stores
	FROM toys_stores
GROUP BY store_city
ORDER BY Total_Stores DESC;

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--🟡INTERMEDIATE SQL QUESTIONS (Joins & Analysis):

--4.JOIN Operations:

/*16. Join Sales And Products To Show:
Sale_ID
Product_Name
Units_Sold*/
SELECT ts.sale_id,
       ts.units_sold,
	   tp.product_name
	FROM toys_sales ts
JOIN toys_products tp
ON tp.product_id = ts.product_id;

--17. Join Inventory With Stores To Show Stock Per Store.
 SELECT tst.store_id,  tst.store_name,
	   ti.stock_on_hand
	 FROM toys_stores tst
JOIN toys_inventory ti
ON ti.store_id = tst.store_id
GROUP BY tst.store_id, tst.store_name, ti.stock_on_hand;
	
--18. Display Sales With Store Name And City.
SELECT tst.store_name,
	   tst.store_city,
	   ts.units_sold
	 FROM toys_stores tst
JOIN toys_sales ts
ON ts.store_id = tst.store_id
GROUP BY tst.store_name, tst.store_city, ts.units_sold;

--19. Show Product Name, Store Name, And Stock-On-Hand.
 SELECT tp.product_name,
 		tst.store_name,
		 ti.stock_on_hand
FROM toys_inventory ti
JOIN toys_products tp
ON tp.product_id = ti.product_id
	JOIN toys_stores tst
	ON tst.store_id = ti.store_id
ORDER BY tp.product_name, 
		 tst.store_name DESC;

--20. Find Sales Where The Product Category Is Toys.
SELECT ts.units_sold,
		tp.product_category
	FROM toys_sales ts
JOIN toys_products tp
ON tp.product_id = ts.product_id
WHERE tp.product_category = 'Toys';

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--5. Revenue & Business Metrics:

--21. Calculate Revenue Per Sale
SELECT
    ts.sale_id,
    ts.transaction_date,
    tp.product_name,
    ts.units_sold,
    tp.product_price,
    ts.units_sold * tp.product_price AS Revenue_Per_Sale
FROM toys_sales ts
JOIN toys_products tp
    ON ts.product_id = tp.product_id;

--22. Calculate Total Revenue Per Product.
SELECT tp.product_id,
       tp.product_name,
SUM(ts.units_sold * tp.product_price) AS Total_Revenue
FROM toys_sales ts
JOIN toys_products tp
ON ts.product_id = tp.product_id
GROUP BY tp.product_id,
		 tp.product_name,
		 tp.product_price
ORDER BY Total_Revenue DESC;

--23. Calculate Total Revenue Per Store.
SELECT tst.store_id,
	   tst.store_name,
SUM(ts.units_sold * tp.product_price) AS Revenue_Per_Store
FROM toys_sales ts
JOIN toys_products tp
ON ts.product_id = tp.product_id
JOIN toys_stores tst
ON ts.store_id = tst.store_id
GROUP BY tst.store_id,
		 tst.store_name
ORDER BY Revenue_per_store DESC;

 --24. Find The Top 5 Best-Selling Products By Revenue.
SELECT tp.product_id,
       tp.product_name,
SUM(ts.units_sold * tp.product_price) AS Total_Revenue
FROM toys_sales ts
JOIN toys_products tp
ON ts.product_id = tp.product_id
GROUP BY tp.product_id,
		 tp.product_name,
		 tp.product_price
ORDER BY Total_Revenue DESC LIMIT 5;
 
--25. Find The Top City By Total Revenue.	 
SELECT
    tst.store_city,
    SUM(ts.units_sold * tp.product_price) AS Total_Revenue
FROM toys_sales ts
JOIN toys_stores tst
    ON ts.store_id = tst.store_id
JOIN toys_products tp
    ON ts.product_id = tp.product_id
GROUP BY tst.store_city
ORDER BY total_revenue DESC LIMIT 10;

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--6.GROUP BY + HAVING:
	   
--26. Find Products With Total Units Sold > 100.
SELECT tp.product_name,
		SUM(ts.units_sold) AS Total_Units_Sold
	FROM toys_sales ts
JOIN toys_products tp
ON ts.product_id = tp.product_id
GROUP BY tp.product_name
HAVING SUM(ts.units_sold) > 100
ORDER BY Total_Units_Sold DESC;

--27. Identify Stores With Revenue Greater Than 50,000.
SELECT tst.store_id,
	   tst.store_name,
	SUM(ts.units_sold * tp.product_price) AS Total_Revenue
FROM toys_sales ts
JOIN toys_stores tst
ON ts.store_id = tst.store_id
JOIN toys_products tp
ON ts.product_id = tp.product_id
GROUP BY tst.store_id,
		 tst.store_name
HAVING SUM(ts.units_sold * tp.product_price) > 50000
ORDER BY Total_Revenue DESC;

--28. Show Categories With Average Price > 15.
SELECT product_category,
		AVG(product_price) AS Average_Price
	FROM toys_products
GROUP BY product_category
		HAVING AVG(product_price) > 15
ORDER BY Average_price DESC;
 
--29. Find Stores That Sold More Than 500 Units Total.
SELECT tst.store_id, 
	   tst.store_name,
	SUM(ts.units_sold) AS Total_Units_Sold
FROM toys_sales ts
	JOIN toys_stores tst
	ON ts.store_id = tst.store_id
GROUP BY tst.store_id,
		 tst.store_name
	HAVING SUM(ts.units_sold) > 500
ORDER BY Total_units_sold DESC;

--30. Show Products That Were Never Sold.
SELECT
    tp.product_id,
    tp.product_name,
    tp.product_category
FROM toys_products tp
LEFT JOIN toys_sales ts
    ON tp.product_id = ts.product_id
WHERE ts.product_id IS NULL;

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--🔵ADVANCED SQL QUESTIONS (Analytics & Optimization):

--7.Time-Based Analysis (using calendar).

--31. Calculate Daily Total Revenue.
SELECT
    ts.transaction_date,
    SUM(ts.units_sold * tp.product_price) AS Daily_Total_Revenue
FROM toys_sales ts
JOIN toys_products tp
    ON ts.product_id = tp.product_id
GROUP BY ts.transaction_date
ORDER BY ts.transaction_date;

--32. Find Monthly Revenue Trends.
SELECT
    DATE_TRUNC('month', ts.transaction_date) AS Month,
    SUM(ts.units_sold * tp.product_price) AS Monthly_Revenue
FROM toys_sales ts
JOIN toys_products tp
    ON ts.product_id = tp.product_id
GROUP BY DATE_TRUNC('month', ts.transaction_date)
ORDER BY month;

--33. Identify The Best Sales Day.
SELECT
    ts.transaction_date,
    SUM(ts.units_sold * tp.product_price) AS Daily_Revenue
FROM toys_sales ts
JOIN toys_products tp
    ON ts.product_id = tp.product_id
GROUP BY ts.transaction_date
ORDER BY daily_revenue DESC
LIMIT 1;


--34. Compare Weekday vs Weekend Sales.
SELECT
    CASE
        WHEN EXTRACT(DOW FROM ts.transaction_date) IN (0, 6)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    SUM(ts.units_sold * tp.product_price) AS Total_Revenue
FROM toys_sales ts
JOIN toys_products tp
    ON ts.product_id = tp.product_id
GROUP BY day_type;

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--8.Inventory Analysis.

--35. Identify Products With Stock < 5 Units.
 SELECT
    tp.product_id,
    tp.product_name,
    tst.store_name,
    ti.stock_on_hand
FROM toys_inventory ti
JOIN toys_products tp
    ON ti.product_id = tp.product_id
JOIN toys_stores tst
    ON ti.store_id = tst.store_id
WHERE ti.stock_on_hand < 5
ORDER BY ti.stock_on_hand, tp.product_name;

SELECT * FROM toys_products;
SELECT * FROM toys_stores;
SELECT * FROM toys_inventory;
SELECT * FROM toys_sales;
SELECT * FROM calendar;	

--9.Window Functions.

--36. Rank Products By Revenue Within Each Category.
SELECT
    tp.product_category,
    tp.product_id,
    tp.product_name,
    SUM(ts.units_sold * tp.product_price) AS Total_Revenue,
    RANK() OVER (
        PARTITION BY tp.product_category
        ORDER BY SUM(ts.units_sold * tp.product_price) DESC
    ) AS Revenue_Rank
FROM toys_sales ts
JOIN toys_products tp
    ON ts.product_id = tp.product_id
GROUP BY
    tp.product_category,
    tp.product_id,
    tp.product_name
ORDER BY
    tp.product_category,
    revenue_rank;

--37. Calculate Running Total Of Revenue By Date.
SELECT
    transaction_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY transaction_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM (
    SELECT
        ts.transaction_date,
        SUM(ts.units_sold * tp.product_price) AS daily_revenue
    FROM toys_sales ts
    JOIN toys_products tp
        ON ts.product_id = tp.product_id
    GROUP BY ts.transaction_date
) t
ORDER BY transaction_date;

--38. Find The Top Product Per Store.
SELECT DISTINCT ON (tst.store_id)
    tst.store_id,
    tst.store_name,
    tp.product_name,
    SUM(ts.units_sold * tp.product_price) AS Total_Revenue
FROM toys_sales ts
JOIN toys_stores tst ON ts.store_id = tst.store_id
JOIN toys_products tp ON ts.product_id = tp.product_id
GROUP BY tst.store_id, tst.store_name, tp.product_name
ORDER BY tst.store_id, total_revenue DESC;