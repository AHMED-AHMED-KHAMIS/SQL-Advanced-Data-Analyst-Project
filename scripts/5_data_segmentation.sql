/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*
Segment products into cost ranges
and counthow many products fall into each segment
*/

WITH Product_segments AS(
SELECT 
	product_key,
	product_name,
	product_cost,
	CASE
		WHEN product_cost < 100 THEN 'Below 100'
		WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM [gold].[dim_products]
)
SELECT 
	cost_range,
	COUNT(product_key) AS Total_Product
FROM Product_segments
GROUP BY cost_range
ORDER BY 1;

/*
Group customers into three segments based on their spending behavior:
- VIP: at least 12 months of history and spending more than $5000.
- Regular: at least 12 months of history but spending $5000 or less.
- new: lifespan less than 12 months. 
*/
WITH customer_spending AS (
SELECT
	customer_key,
	MIN(order_date) AS first_purchase_date,
	DATEDIFF(MONTH,MIN(order_date),MAX(order_date))AS  months_since_first_purchase,
	SUM(sales_amount)AS Total_Spending
FROM [gold].[fact_sales]
GROUP BY customer_key

)
SELECT 
	Spending_range,
	COUNT(customer_key)AS Total_Customer
FROM(
SELECT	
	customer_key,
	Total_Spending,
	months_since_first_purchase,
	CASE
		WHEN Total_Spending > 5000  AND months_since_first_purchase >= 12 THEN 'VIP'
		WHEN Total_Spending <= 5000  AND months_since_first_purchase >= 12 THEN 'Regular'
		ELSE 'New'
	END AS Spending_range
FROM customer_spending)t
GROUP BY Spending_range
ORDER BY Total_Customer DESC;

-- Customer Segmentation
SELECT 
	gender,
	COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;


-- Country Segmentation
SELECT 
	country,
	COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Product Segmentation By Category AND Subcategory
SELECT 
	category,
	subcategory,
	COUNT(*) AS Total_Number
FROM gold.dim_products 
WHERE category IS NOT NULL AND subcategory IS NOT NULL
GROUP BY category, subcategory
ORDER BY Total_Number DESC;



--Number of purchases per customer
SELECT 
  customer_key,
  COUNT(DISTINCT order_number) AS order_count,
  CASE 
    WHEN COUNT(DISTINCT order_number) >= 10 THEN 'Frequent'
    WHEN COUNT(DISTINCT order_number) >= 4 THEN 'Occasional'
    ELSE 'Infrequent'
  END AS purchase_frequency_segment
FROM gold.fact_sales
GROUP BY customer_key
ORDER BY order_count DESC;
