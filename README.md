**Project Overview**

Project Title: Retail Sales Analysis<br /> 
Level: Beginner<br />
Database: Sql_Project1

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

**Objectives**

Set up a retail sales database: Create and populate a retail sales database with the provided sales data.<br />
Data Cleaning: Identify and remove any records with missing or null values.<br />
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.<br />
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.<br />


**Project Structure**

**1. Database Setup**
   
**Database Creation:** The project starts by creating a database named sql_project1.<br />
**Table Creation:** A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.<br />

CREATE DATABASE Sql_Project1;

CREATE TABLE retail_sales<br />
(<br />
    transactions_id INT PRIMARY KEY,<br />
    sale_date DATE,<br />	
    sale_time TIME,<br />
    customer_id INT,<br />	
    gender VARCHAR(10),<br />
    age INT,<br />
    category VARCHAR(35),<br />
    quantity INT,<br />
    price_per_unit FLOAT,<br />	
    cogs FLOAT,<br />
    total_sale FLOAT<br />
);

**2. Data Exploration & Cleaning**

Record Count: Total Number of transactions made.<br />
Customer Count: Find out how many unique customers are in the dataset.<br />
Null Value Check: Check for any null values in the dataset and delete records with missing data.<br />

SELECT<br />
	COUNT(transactions_id) as Total_transactions<br />
FROM retail_sales;<br />
	
--Find out count of unique transactions customers?
SELECT<br />
	COUNT(DISTINCT customer_id)<br />
FROM retail_sales;<br />

SELECT * FROM retail_sales<br />
WHERE <br />
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR <br />
    gender IS NULL OR age IS NULL OR category IS NULL OR <br />
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;<br />

DELETE FROM retail_sales<br />
WHERE <br />
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR <br />
    gender IS NULL OR age IS NULL OR category IS NULL OR <br />
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;<br />

**3. Data Analysis & Findings**

The following SQL queries were developed to answer specific business questions:

**1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:**

SELECT<br />
	*<br />
FROM retail_sales<br />
WHERE sale_date = '2022-11-05'<br />

**2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:**


SELECT<br />
	*<br />
FROM retail_sales<br />
WHERE category = 'Clothing'<br />
AND quantity >= 4<br />
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'<br />

**3. Write a SQL query to calculate the total sales (total_sale) for each category.:**

SELECT<br />
	category,<br />
	SUM(total_sale)<br />
FROM retail_sales<br />
GROUP BY category;<br />

**4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:**

SELECT<br />
	category,<br />
	ROUND(AVG(age),0) as Avg_Age<br />
FROM retail_sales<br />
WHERE category = 'Beauty'<br />
GROUP BY 1<br />

**5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:**

SELECT<br />
	transactions_id,<br />
	SUM(total_sale) as total_sales<br />
FROM retail_sales<br />
GROUP BY 1<br />
HAVING SUM(total_sale) > 1000<br />
ORDER BY total_sales asc;<br />

**6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:**
	
SELECT<br />
	category,<br />
	gender,<br />
	COUNT(transactions_id) as Total_transactions<br />
FROM retail_sales<br />
GROUP BY 1,2<br />
ORDER BY category asc<br />

**7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:**

SELECT<br />
	year,<br />
	month,<br />
	avg_sale<br />
FROM<br />
(<br />
SELECT<br />
	EXTRACT(YEAR FROM sale_date) as year,<br />
	EXTRACT(MONTH FROM sale_date) as month,<br />
	AVG(total_sale) :: INT as avg_sale,<br />
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank<br />
FROM retail_sales<br />
GROUP BY 1,2<br />
) as t1<br />
WHERE rank = 1<br />

**8. Write a SQL query to find the top 5 customers based on the highest total sales:**

SELECT<br />
	customer_id,<br />
	SUM(total_sale) as total_sales<br />
FROM retail_sales<br />
GROUP BY 1<br />
ORDER BY 2 DESC<br />
LIMIT 5<br />


**9. Write a SQL query to find the number of unique customers who purchased items from each category.:**

SELECT<br />
	category,<br />
	COUNT(DISTINCT customer_id) as customer_count<br />
FROM retail_sales<br />
GROUP BY 1<br />
ORDER BY 2 DESC<br />


**10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):**

SELECT * FROM retail_sales<br />

SELECT<br />
	shift,<br />
	COUNT(DISTINCT transactions_id) as orders<br />
FROM<br />
(<br />
SELECT<br />
	*,<br />
	CASE<br />
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'<br />
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'<br />
		ELSE 'Evening'<br />
	END as shift<br />
FROM retail_sales<br />
)as t1<br />
GROUP BY shift<br />
ORDER BY orders DESC<br />

-- Same query using CTE<br />

WITH hourly_sale<br />
AS<br />
(<br />
SELECT *,<br />
    CASE<br />
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'<br />
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'<br />
        ELSE 'Evening'<br />
    END as shift<br />
FROM retail_sales<br />
)<br />
SELECT <br />
    shift,<br />
    COUNT(*) as total_orders<br />  
FROM hourly_sale<br />
GROUP BY shift<br />

**11. Find out the total sales in each category gender-wise. Identify which gender contributed highest sale in each category.**
SELECT<br />
	rank,<br />
	gender,<br />
	category,<br />
	Total_Sales<br />
FROM<br />
(<br />
SELECT<br />
	category,<br />
	gender,<br />
	SUM(total_sale) as Total_Sales,<br />
	RANK() OVER(PARTITION BY category ORDER BY SUM(total_sale) DESC) AS rank<br />
FROM retail_sales<br />
GROUP BY 1,2<br />
) as t1<br />

**12. Write sql query to find out category wise profit and it's margin.**

SELECT<br />
	category,<br />
	SUM(total_sale) AS Total_Sales,<br />
	SUM(total_sale) - SUM(cogs) ::INT as Profit,<br />
	((SUM(total_sale) - SUM(cogs))/SUM(total_sale))*100 as GP_Margin<br />
FROM retail_sales<br />
GROUP BY 1<br />
ORDER BY GP_Margin DESC<br />

**Findings**

**Customer Demographics:** The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.<br />
**High-Value Transactions:** Several transactions had a total sale amount greater than 1000, indicating premium purchases.<br />
**Sales Trends:** Monthly analysis shows variations in sales, helping identify peak seasons.<br />
**Customer Insights:** The analysis identifies the top-spending customers and the most popular product categories.<br />

**Conclusion**

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

