/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
SELECT 
	YEAR(order_date) AS Order_Year,
	SUM(sales_amount)AS Total_Sales,
	COUNT(DISTINCT customer_key)AS Total_Customers,
	SUM(quantity) AS Total_Quanitiy
FROM [gold].[fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

--

SELECT 
	YEAR(order_date) AS Order_Year,
	MONTH(order_date) AS Order_Month,
	SUM(sales_amount)AS Total_Sales,
	COUNT(DISTINCT customer_key)AS Total_Customers,
	SUM(quantity) AS Total_Quanitiy
FROM [gold].[fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date);

