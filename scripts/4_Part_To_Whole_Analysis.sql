/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- which categories contribute the most to overall sales
WITH category_sales AS(
SELECT 
	category,
	SUM(sales_amount)AS Total_sale
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
	ON p.product_key=f.product_key
GROUP BY category
) 
SELECT 
	category,
	Total_sale,
	SUM(Total_sale) OVER () AS Overall_sales,
	CONCAT(ROUND((CAST(Total_sale AS FLOAT) / SUM(Total_sale) OVER ())*100,2),'%')AS Percentage_of_Total
FROM category_sales
ORDER BY Total_sale DESC;

--  Top Subcategories by Total Sales

WITH subcategory_sales AS(
SELECT 
	subcategory,
	SUM(sales_amount)AS Total_sale
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
	ON p.product_key=f.product_key
GROUP BY subcategory
) 
SELECT 
	subcategory,
	Total_sale,
	SUM(Total_sale) OVER () AS Overall_sales,
	CONCAT(ROUND((CAST(Total_sale AS FLOAT) / SUM(Total_sale) OVER ())*100,2),'%')AS Percentage_of_Total
FROM subcategory_sales
ORDER BY Total_sale DESC;



-- Top Categories by Total Number of Orders
WITH category_orders AS (
    SELECT 
        p.category,
        COUNT(DISTINCT f.order_number) AS total_orders
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT 
    category,
    total_orders,
    SUM(total_orders) OVER () AS overall_orders,
    CONCAT(ROUND((CAST(total_orders AS FLOAT) / SUM(total_orders) OVER()) * 100, 2), '%') AS percentage_of_total
FROM category_orders
ORDER BY total_orders DESC;

-- Top Categories by Number of Unique Customers
WITH category_customers AS (
    SELECT 
        p.category,
        COUNT(DISTINCT f.customer_key) AS total_customers
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT 
    category,
    total_customers,
    SUM(total_customers) OVER () AS overall_customers,
    CONCAT(ROUND((CAST(total_customers AS FLOAT) / SUM(total_customers) OVER()) * 100, 2), '%') AS percentage_of_total
FROM category_customers
ORDER BY total_customers DESC;


--Sales Breakdown by Gender
WITH gender_sales AS (
    SELECT 
        c.gender,
        COUNT(DISTINCT f.customer_key) AS total_customers
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    GROUP BY c.gender
)
SELECT 
    gender,
    total_customers,
    SUM(total_customers) OVER () AS overall_customers,
    CONCAT(ROUND((CAST(total_customers AS FLOAT) / SUM(total_customers) OVER()) * 100, 2), '%') AS percentage_of_total
FROM gender_sales
ORDER BY total_customers DESC;

-- Customer Marital Status Breakdown
SELECT 
    marital_status,
    COUNT(*) AS total_customers,
    SUM(COUNT(*)) OVER () AS overall_customers,
    CONCAT(ROUND(CAST(COUNT(*) AS FLOAT) / SUM(COUNT(*)) OVER () * 100, 2), '%') AS percentage_of_total
FROM gold.dim_customers
GROUP BY marital_status;

-- Sales by Country (Customer Location)
SELECT 
    country,
    SUM(sales_amount) AS total_sales,
    SUM(SUM(sales_amount)) OVER () AS overall_sales,
    CONCAT(ROUND(CAST(SUM(sales_amount) AS FLOAT) / SUM(SUM(sales_amount)) OVER () * 100, 2), '%') AS percentage_of_total
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY country;

