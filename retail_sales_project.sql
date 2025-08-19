-- Retail Sales Analysis Quaries

-- Q1. Retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q2. Retrieve all transactions where category is 'Clothing'and quantity sold > 4 in November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- Q3. Calculate total sales for each category
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;


-- Q4. Find the average age of customers who purchased items from 'Beauty' category
SELECT ROUND(AVG(age), 0) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q5. Find all transactions where total_sale > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- Q6. Find total number of transactions made by each gender in each category
SELECT gender, category, COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category;


-- Q7. Calculate average sale for each month and find best-selling month in each year
-- Average sale per month
SELECT 
    YEAR(sale_date) AS sales_year,
    MONTH(sale_date) AS sales_month,
    ROUND(AVG(total_sale), 2) AS avg_monthly_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date);

-- Best-selling month in each year
SELECT sales_year, sales_month, avg_monthly_sale
FROM (
    SELECT 
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        ROUND(AVG(total_sale), 2) AS avg_monthly_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS sales_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_sales
WHERE sales_rank = 1;

-- Q8. Find the top 5 customers based on highest total sales
SELECT TOP 5 
       customer_id, 
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q9. Find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10. Create each shift and number of orders Morning <12, Afternoon 12-17, Evening >17
SELECT 
    CASE 
        WHEN CAST(sale_time AS TIME) < '12:00:00' THEN 'Morning'
        WHEN CAST(sale_time AS TIME) BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 
    CASE 
        WHEN CAST(sale_time AS TIME) < '12:00:00' THEN 'Morning'
        WHEN CAST(sale_time AS TIME) BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END;
