/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

	
/*  
	Analyze the yearly Performance of Products
	by comparing each Product's sales to both 
	its average sales performance and the previous year's sales 
*/
WITH Yearly_product__sales AS (
SELECT 
	YEAR(f.order_date) AS Order_Year,
	p.product_name,
	SUM(f.sales_amount) AS Current_Total_Sales
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
	ON p.product_key=f.product_key
WHERE f.order_date IS NOT NULL
GROUP BY YEAR(f.order_date),p.product_name
)
SELECT 
	Order_Year,
	Product_Name,
	Current_Total_Sales,
	AVG(Current_Total_Sales) OVER (PARTITION BY product_name)AS Avg_Sales,
	Current_Total_sales - AVG(Current_Total_sales) OVER (PARTITION BY product_name) AS Diff_Avg_Changes,
	CASE
		WHEN Current_Total_sales - AVG(Current_Total_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN Current_Total_sales - AVG(Current_Total_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS Avg_Changes_Indicator,
	LAG(Current_Total_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) AS Previous_Year_Total_Sales,
	Current_Total_Sales - LAG(Current_Total_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) AS Difference_Between_Pre_Curr,
	CASE 
		WHEN Current_Total_sales - LAG(Current_Total_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) > 0 THEN 'Increasing'
		WHEN Current_Total_sales - LAG(Current_Total_Sales) OVER (PARTITION BY product_name ORDER BY Order_Year) < 0 THEN 'Decreasing'
		ELSE 'No Change'
	END AS Curr_and_Pre_Changes_Indicator	
FROM Yearly_product__sales;
