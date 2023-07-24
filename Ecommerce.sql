--KPI
--YTD Sales
SELECT ROUND(SUM(sales_per_order),2) AS 'YTD Sales'
FROM ecommerce_data
GROUP BY YEAR(order_date)
HAVING YEAR(order_date) = 2022

--YTD Sales per Month
SELECT MONTH(order_date) AS 'Month', ROUND(SUM(sales_per_order),2) AS 'YTD Sales'
FROM ecommerce_data
WHERE YEAR(order_date) = 2022
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

--YTD Sales Rate vs PYTD Sales
SELECT YEAR(order_date) as year, SUM(sales_per_order) as sales, SUM(profit_per_order) as profit, SUM(order_quantity) as quantity, SUM(profit_per_order)/SUM(sales_per_order) as 'profit margin'
FROM ecommerce_data
GROUP BY YEAR(order_date)

CREATE TABLE #temp_KPI_Analysis(
Year float,
Sales float,
Profit float,
Quantity int,
Profit_Margin float)

INSERT INTO #temp_KPI_Analysis
SELECT YEAR(order_date), SUM(sales_per_order), SUM(profit_per_order), SUM(order_quantity), SUM(profit_per_order)/SUM(sales_per_order)
FROM ecommerce_data
GROUP BY YEAR(order_date)

SELECT PYTD.Year, ROUND(PYTD.Sales,2), YTD.Year, ROUND(YTD.Sales,2), ROUND(100 * (YTD.Sales-PYTD.Sales)/PYTD.Sales,2)
FROM #temp_KPI_Analysis PYTD LEFT JOIN #temp_KPI_Analysis YTD
ON (PYTD.Year = YTD.Year-1)

SELECT PYTD.Year, ROUND(PYTD.Profit,2), YTD.Year, ROUND(YTD.Profit,2), ROUND(100 * (YTD.Profit-PYTD.Profit)/PYTD.Profit,2)
FROM #temp_KPI_Analysis PYTD LEFT JOIN #temp_KPI_Analysis YTD
ON (PYTD.Year = YTD.Year-1)

SELECT PYTD.Year, ROUND(PYTD.Quantity,2), YTD.Year, ROUND(YTD.Quantity,2), ROUND(100 * (CONVERT(float, YTD.Quantity)-PYTD.Quantity)/PYTD.Quantity,2)
FROM #temp_KPI_Analysis PYTD LEFT JOIN #temp_KPI_Analysis YTD
ON (PYTD.Year = YTD.Year-1)

SELECT PYTD.Year, ROUND(PYTD.Profit_Margin,2), YTD.Year, ROUND(YTD.Profit_Margin,2), ROUND(100 * (CONVERT(float, YTD.Profit_Margin)-PYTD.Profit_Margin)/PYTD.Profit_Margin,2)
FROM #temp_KPI_Analysis PYTD LEFT JOIN #temp_KPI_Analysis YTD
ON (PYTD.Year = YTD.Year-1)

--YTD Sales by Category
WITH cte_sales_category (year, category_name, Sales) AS (
SELECT YEAR(order_date), category_name, ROUND(SUM(sales_per_order),2) AS Sales
FROM ecommerce_data
GROUP BY YEAR(order_date), category_name
)
SELECT PYTD.category_name, YTD.year, YTD.sales, PYTD.year, PYTD.sales, 100*(YTD.sales-PYTD.sales)/PYTD.sales
FROM cte_sales_category PYTD LEFT JOIN cte_sales_category YTD ON
(PYTD.year = YTD.year-1 AND
PYTD.category_name = YTD.category_name
)
WHERE YTD.year IS NOT NULL


--Sales by State
SELECT customer_state, ROUND(SUM(sales_per_order),2) AS YTD_Sales
FROM ecommerce_data
WHERE YEAR(order_date) = 2022
GROUP BY customer_state
ORDER BY SUM(sales_per_order) DESC

--Top 5 Product YTD Sales
SELECT TOP (5)  product_name, ROUND(SUM(sales_per_order),2) AS YTD_Sales
FROM ecommerce_data
WHERE YEAR(order_date) = 2022
GROUP BY product_name
ORDER BY YTD_Sales DESC

--BOTTOM 5 Product YTD Sales
SELECT TOP (5)  product_name, ROUND(SUM(sales_per_order),2) AS YTD_Sales
FROM ecommerce_data
WHERE YEAR(order_date) = 2022
GROUP BY product_name
ORDER BY YTD_Sales ASC


--YTD Sales by Ragion
SELECT customer_region, SUM(sales_per_order) AS YTD_Sales
FROM ecommerce_data
WHERE YEAR(order_date) = 2022
GROUP BY customer_region
ORDER BY YTD_Sales DESC


--YTD Sales by Shipping Types
SELECT shipping_type, ROUND(SUM(sales_per_order),2) AS YTD_Sales
FROM ecommerce_data
WHERE YEAR(order_date) = 2022
GROUP BY shipping_type
ORDER BY YTD_Sales DESC

