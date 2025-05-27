/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


--	Calculate the total sales per month
-- And the running total of sales over time


-- Monthly
SELECT 
	Order_Year,
	Order_Month,
	Total_Sales,
	SUM(Total_Sales) OVER (PARTITION BY Order_year ORDER BY Order_Month ASC)AS Running_Total_Sales
FROM(
SELECT
	YEAR(order_date)AS Order_Year,
	MONTH(order_date) AS Order_Month,
	SUM(sales_amount) AS Total_Sales
FROM [gold].[fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date) 
) t;

-- Yearly 
SELECT 
	Order_Year,
	Total_Sales,
	SUM(Total_Sales) OVER (ORDER BY Order_year)AS Running_Total_Sales,
	AVG(Avg_price) OVER (ORDER BY Order_year)AS Avg_price_changing
FROM(
SELECT
	YEAR(order_date)AS Order_Year,
	SUM(sales_amount) AS Total_Sales,
	AVG(price) AS Avg_price
FROM [gold].[fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
) t;


