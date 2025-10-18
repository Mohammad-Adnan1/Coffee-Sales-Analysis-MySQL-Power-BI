-- KPI's REQUIREMENTS

-- (1) TOTAL SALES ANALYSIS

-- a. Total Sales For Month

SELECT concat(ROUND(SUM(unit_price * transaction_qty)/1000), "K") as Total_Sales 
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5; -- for month of (CM-May)

-- b. MoM Difference And MoM Growth in Sales

SELECT 
    MONTH(transaction_date)AS Month, -- Month Number
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales, -- Total Sale
ROUND(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) As Moth_Sales_Diff, -- Moth Sales Diff
    ROUND((SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100,1) AS MoM_Increase_Percentage -- MoM Increase %
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


-- (2) TOTAL ORDER ANALYSIS


-- a. Total Order For Month

SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5; -- for month of (CM-May)


-- b. MoM Difference And MoM Growth in Order


SELECT 
    MONTH(transaction_date) AS Month,
    ROUND(COUNT(transaction_id)) AS Total_Orders,
    COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) AS Month_Order_Diff,
	ROUND((COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100,1) AS MoM_Increase_Percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);


-- (3) TOTAL QUANTITY SOLD ANALYSIS

-- a. Total Quantity Sold For Month

SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5; -- for month of (CM-May)


-- b. MoM Difference And MoM Growth in Sold Quantity

SELECT 
    MONTH(transaction_date) AS Month,
    ROUND(SUM(transaction_qty)) AS Total_Quantity_Sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) as Month_Sold_Quantiy_Diff,
    ROUND((SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100,1) AS MoM_Increase_Percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- CHARTS REQUIREMENTS

-- For Calendar Table – Daily Sales, Quantity And Total Orders

SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    COUNT(transaction_id) AS Total_Orders,
    SUM(transaction_qty) AS Total_Quantity_Sold
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023
    
    -- or
    
    SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS Total_Sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS Total_Orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS Total_Quantity_Sold
    
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023
    
-- Sales By Weekday / Weekend:

SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS Day_Type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000),'K') AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;


-- Sales By Store Location

SELECT 
	Store_Location,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 -- For May
GROUP BY Store_Location
ORDER BY Total_Sales DESC;


-- Sales Trend Over Period


SELECT ROUND(AVG(total_sales)) AS Average_Sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;


-- Daily Sales For Month Selected


SELECT 
    DAY(transaction_date) AS Day_of_Month,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);
    

-- Comparing Daily Sales With Average Sales – If Greater Than “Above Average” And Lesser Than “Below Average”


SELECT 
    Day_of_Month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS Sales_Status,
    Avg_Sales,
    Total_Sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
ROUND(AVG(SUM(unit_price * transaction_qty)) OVER ()) AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- For May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

    
-- Sales By Product Category


SELECT 
	Product_Category,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 -- For May
GROUP BY product_category
ORDER BY Total_Sales DESC;


-- Sales By Products (Top 10)


SELECT 
	Product_Type,
	CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),'K') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;


-- Sales By Day | Hour



SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    COUNT(*) AS Total_Orders,
    SUM(transaction_qty) AS Total_Quantity
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 2 -- For Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- For hour number 8
    AND MONTH(transaction_date) = 5; -- For May



-- To Get Sales For All Hours For Month


SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- For May 
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);


-- To Get Sales From Monday To Sunday For Month



SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000),'K') AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- For May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;








