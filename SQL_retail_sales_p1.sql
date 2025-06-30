-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p1a;

CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE, 
				sale_time	TIME,
				customer_id	INT,
				gender VARCHAR (15),	
				age	INT,
				category VARCHAR (15),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale INT
			);
SELECT *
FROM retail_sales;


SELECT*
FROM retail_sales
LIMIT 10;


SELECT COUNT (*)
FROM retail_sales;

-- Data Cleaning

SELECT*
FROM retail_sales
WHERE TRANSACTIONS_ID IS NULL;


SELECT*
FROM retail_sales
WHERE SALE_DATE IS NULL;


SELECT*
FROM retail_sales
WHERE SALE_TIME IS NULL;


SELECT*
FROM retail_sales
WHERE CUSTOMER_ID IS NULL;


SELECT*
FROM retail_sales
WHERE AGE IS NULL
OR CATEGORY IS NULL
OR QUANTIY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL;

DELETE
FROM retail_sales
WHERE AGE IS NULL
OR CATEGORY IS NULL
OR QUANTIY IS NULL
OR PRICE_PER_UNIT IS NULL
OR COGS IS NULL
OR TOTAL_SALE IS NULL;

--Data Exploration
--How many total sales we have?
SELECT COUNT(*) AS TOTAL_SALE
FROM retail_sales;
--How many unique customers do we have?
SELECT COUNT (distinct CUSTOMER_ID) as total_sale
FROM retail_sales;
--How many unique categories do we have?
SELECT COUNT (distinct category) as total_sale
FROM retail_sales;
--What unique categories do we have?
SELECT distinct category as total_sale
FROM retail_sales;

--Data Analysis OR Business Key Problems and Answers.
--1. Retrieve all columns for sales made on 2022-11-05.
SELECT *
FROM retail_sales
WHERE sale_date= '2022-11-05';


--2. Retrieve all transactions whre category is 'clothing' and the quantity sold is more than 4 in the month of November 2022.
SELECT*
FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTIY>=4;

--3. Calculate total sales for each category
SELECT 
	CATEGORY,
	SUM(total_sale) AS NET_SALES,
	COUNT (TOTAL_SALE) as TOTAL_ORDERS
FROM retail_sales
GROUP BY CATEGORY;

--4. Retrieve average age of customers who purchased items from 'Beauty' category.

SELECT
	AVG(AGE)
FROM retail_sales
WHERE category= 'Beauty';
-- Since the number has too many decimals and is not easily readable we can go for round function.
SELECT
	ROUND(AVG(age),2)  Avg_age
FROM retail_sales
WHERE category='Beauty';

--5. Retrieve the transactions where total_sales value is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_Sale> 1000;

--6. Find total number of transactions made by each gender in each category.
SELECT
	gender,
	category,
	COUNT(transactions_id)  transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY 2;

--7. Calculate average sale for each month and find out best selling month in each year.
WITH monthly_avg AS
(
SELECT
	EXTRACT (YEAR FROM sale_date) AS year,
	EXTRACT (MONTH FROM sale_date) AS month,
	ROUND(AVG(total_sale),2) avg_monthly_sale
FROM
	retail_sales
GROUP BY
	EXTRACT (YEAR FROM sale_date),
	EXTRACT (MONTH FROM sale_date)
ORDER BY
	EXTRACT (YEAR FROM sale_date),
	EXTRACT (MONTH FROM sale_date)
)
SELECT*
FROM 
	monthly_avg AS m
WHERE 
	avg_monthly_sale = 
	(
		SELECT 
			MAX(avg_monthly_sale)
		FROM monthly_avg
		WHERE year= m.year)
ORDER BY year;

--8. Find top 5 customers based on highest total sales.
SELECT
	customer_id,
	SUM (total_sale)
FROM 
	retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--9. Find the number of unique customers who purchased items from each category.

SELECT
	category,
	COUNT(DISTINCT(customer_id)) AS cnt_unq_cst
FROM retail_sales
GROUP BY 1;

--10. Write a query to create each shift and number of orders (eg- Morning<12; Afternoon 12-17; Evening>17)
WITH hourly_sales AS
(
SELECT *,
	CASE
		WHEN (EXTRACT (HOUR FROM sale_time) < 12) THEN 'Morning'
		WHEN (EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND  17) THEN 'Afternoon'
		ELSE 'Evening'
	END AS Shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(transactions_id) AS num_orders
FROM hourly_sales
GROUP BY 1;

--END OF PROJECT--