SELECT * FROM retail_sales


DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
	--- DATA EXPLORATION
	
	--No.of transactions made? - 1987
	SELECT
		COUNT(transactions_id) as Total_transactions
	FROM retail_sales;
	
	--Find out count of unique transactions customers - 155
	SELECT
		COUNT(DISTINCT customer_id)
	FROM retail_sales;
	
--- DATA ANALYSIS USING BUSINESS PROBLEMS

--Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT
	*
FROM retail_sales
WHERE sale_date = '2022-11-05'

--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT
	*
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND TO_CHAR(sale_date,'YYYY-MM') = '2022-11'

--Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT
	category,
	SUM(total_sale)
FROM retail_sales
GROUP BY category;


--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT
	category,
	ROUND(AVG(age),0) as Avg_Age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1

--Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT
	transactions_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
HAVING SUM(total_sale) > 1000
ORDER BY total_sales asc;

--2nd Method

SELECT * FROM retail_sales
WHERE total_sale > 1000

--Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
	
SELECT
	category,
	gender,
	COUNT(transactions_id) as Total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY category asc

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT
	year,
	month,
	avg_sale
FROM
(
SELECT
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) :: INT as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1

--Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


--Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT
	category,
	COUNT(DISTINCT customer_id) as customer_count
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC


--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT * FROM retail_sales

SELECT
	shift,
	COUNT(DISTINCT transactions_id) as orders
FROM
(
SELECT
	*,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)as t1
GROUP BY shift
ORDER BY orders DESC

-- Same query using CTE

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- Find out the total sales in each category gender-wise. Identify which gender contributed highest sale in each category.
SELECT
	rank,
	gender,
	category,
	Total_Sales
FROM
(
SELECT
	category,
	gender,
	SUM(total_sale) as Total_Sales,
	RANK() OVER(PARTITION BY category ORDER BY SUM(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) as t1

--Write sql query to find out category wise profit and it's margin.

SELECT
	category,
	SUM(total_sale) AS Total_Sales,
	SUM(total_sale) - SUM(cogs) ::INT as Profit,
	((SUM(total_sale) - SUM(cogs))/SUM(total_sale))*100 as GP_Margin
FROM retail_sales
GROUP BY 1
ORDER BY GP_Margin DESC
