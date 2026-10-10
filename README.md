# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and replace records with average data.

```sql

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
```

### Replacing Null Values
```sql	 
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
```

```sql
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


SELECT COUNT(*) AS total_record 
FROM retail_sales ;


SELECT COUNT(*) AS total_sales 
FROM retail_sales ;

SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM retail_sales ;

SELECT DISTINCT(category) FROM retail_sales ;

SELECT category , COUNT(category) AS total_category
FROM retail_sales 
GROUP BY category ;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Q.1 Write a SQL query to retrieve all columns for sales made on 2022-11-05**:
```sql
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'
ORDER BY transactions_id;

```
2. **Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 18 in
                    ---the month of Nov-2022**

```sql
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
```
3. **Q.3 Write a SQL query to calculate the total sales (total_sale) for each category**:

```sql
SELECT category , 
SUM(total_sale) AS total_sale_category,
COUNT(*) AS total_orders 
FROM retail_sales 
GROUP BY category 
ORDER BY SUM(total_sale); 
```

4. **Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**:
```sql
SELECT ROUND(AVG(age) ,2)AS avg_age , category 
FROM retail_sales  
GROUP BY category 
HAVING category = 'Beauty' ;
```

5. **Q.5 Write a SQL query to find all transactions where the total sale is greater than 1000**: 

```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000 
ORDER BY transactions_id ;
```
6. **Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**:

```sql
WITH total_number_transactions AS ( 
                SELECT category , gender , COUNT(transactions_id) AS total_trans
				FROM retail_sales
				GROUP BY category , gender 
				ORDER BY COUNT(transactions_id) DESC
				 )
SELECT * FROM total_number_transactions ;
```
7. **Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

```sql
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
```

8. **Q.8 Write a SQL query to find the top 5 customers based on the highest total sales**:

```sql
SELECT customer_id , SUM(total_sale) AS high_total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC , customer_id
LIMIT 5;
```

9. **Q.9 Write a SQL query to find the number of unique customers who purchased items from each category**:

```SQL
SELECT category , COUNT(DISTINCT customer_id)  AS unique_customers
FROM retail_sales 
GROUP BY category ;
```

10. **Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

``` sql
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
```
--- END OF PROJECT 



## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
