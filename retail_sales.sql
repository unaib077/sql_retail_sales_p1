
CREATE TABLE retail_sales (

         transactions_id INT PRIMARY KEY ,  
		 sale_date	DATE ,
		 sale_time TIME ,
		 customer_id INT ,
		 gender VARCHAR(50) ,
		 age INT , 
		 category VARCHAR(50) ,
		 quantiy INT , 
		 price_per_unit FLOAT , 
		 cogs FLOAT , 
		 total_sale FLOAT 
) ; 


---- DATA CLEANING 

SELECT * FROM retail_sales 
LIMIT 100;

SELECT 
   COUNT(*) FROM retail_sales ;

  
SELECT * FROM retail_sales 
WHERE  
     transactions_id IS NULL 
	 OR 
	 sale_date IS NULL 
	 OR 
	 sale_time IS NULL 
	 OR 
	 customer_id IS NULL 
	 OR 
	 gender IS NULL 
	 OR 
	 age IS NULL 
	 OR 
	 category IS NULL 
	 OR 
	 quantiy IS NULL 
	 OR
	 price_per_unit IS NULL 
	 OR 
	 cogs IS NULL 
	 OR 
	 total_sale IS NULL ;


	 
UPDATE retail_sales 
SET age = (SELECT AVG(age) FROM retail_sales)
WHERE age IS NULL ;



UPDATE retail_sales 
SET quantiy = (SELECT AVG(quantiy) FROM retail_sales)
WHERE quantiy IS NULL ;


UPDATE retail_sales 
SET price_per_unit = (SELECT AVG(price_per_unit) FROM retail_sales)
WHERE price_per_unit IS NULL ;

UPDATE retail_sales 
SET cogs = (SELECT AVG(cogs) FROM retail_sales)
WHERE cogs IS NULL ;


UPDATE retail_sales 
SET total_sale = (SELECT AVG(total_sale) FROM retail_sales)
WHERE total_sale IS NULL ;



SELECT * FROM retail_sales 
WHERE  
     transactions_id IS NULL 
	 OR 
	 sale_date IS NULL 
	 OR 
	 sale_time IS NULL 
	 OR 
	 customer_id IS NULL 
	 OR 
	 gender IS NULL 
	 OR 
	 age IS NULL 
	 OR 
	 category IS NULL 
	 OR 
	 quantiy IS NULL 
	 OR
	 price_per_unit IS NULL 
	 OR 
	 cogs IS NULL 
	 OR 
	 total_sale IS NULL ;

-- 
SELECT COUNT(*) AS total_record 
FROM retail_sales ;


-- DATA EXPLORATION 

--1. How many sales we have ?

SELECT COUNT(*) AS total_sales 
FROM retail_sales ;

--2. How many unnique customers we have ?

SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales ;


-- How many category we have ?

SELECT DISTINCT(category) FROM retail_sales ;

-- Count of each category ?

SELECT category , COUNT(category) AS total_category
FROM retail_sales 
GROUP BY category ;

--- DATA ANALYSIS & BUSINESS KEY PROBLEMS 
----Data Analysis & Business Key Problems & Answers
  ---My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on 2022-11-05

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'
ORDER BY transactions_id;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 18 in
                    ---the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
   category = 'Clothing'
   AND 
   quantiy >= 4 
   AND 
   sale_date >= DATE '2022-11-01'
   AND 
   sale_date < DATE '2022-12-01' 
ORDER BY transactions_id;

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category , 
SUM(total_sale) AS total_sale_category,
COUNT(*) AS total_orders 
FROM retail_sales 
GROUP BY category 
ORDER BY SUM(total_sale); 


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT ROUND(AVG(age) ,2)AS avg_age , category 
FROM retail_sales  
GROUP BY category 
HAVING category = 'Beauty' ;


--Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000. 

SELECT * FROM retail_sales
WHERE total_sale > 1000 
ORDER BY transactions_id ;

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

WITH total_number_transactions AS ( 
                SELECT category , gender , COUNT(transactions_id) AS total_trans
				FROM retail_sales
				GROUP BY category , gender 
				ORDER BY COUNT(transactions_id) DESC
				 )
SELECT * FROM total_number_transactions ;

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


WITH high_selling_month AS (
		SELECT 
		    EXTRACT(month FROM sale_date) AS month ,
			AVG(total_sale) AS avg_sale ,
			EXTRACT(year FROM sale_date) AS year ,
			ROW_NUMBER() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS row_num
		FROM retail_sales 
		GROUP BY month , year
		ORDER BY month ,  year , row_num 
		)
SELECT * FROM high_selling_month 
WHERE row_num = 1
;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id , SUM(total_sale) AS high_total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC , customer_id
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category , COUNT(DISTINCT customer_id)  AS unique_customers
FROM retail_sales 
GROUP BY category ;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH shift AS(
		SELECT *,
		    CASE 
			  WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			  ELSE 'EVENING'
			  END AS work_shift
		FROM retail_sales 
)

SELECT work_shift , count(*) AS total_orders
FROM shift 
GROUP BY work_shift;

--- END OF PROJECT 













