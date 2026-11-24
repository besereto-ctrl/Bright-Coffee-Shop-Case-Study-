CREATE  CATALOG IF NOT EXISTS Retail;
CREATE SCHEMA IF NOT EXISTS sales;


SELECT * FROM Retail.sales.brightcoffee;

SELECT transaction_id,
CAST(replace(unit_price,',','.') AS double) AS unit_price
FROM Retail.sales.brightcoffee;



--Check number of records
SELECT COUNT (*) AS Total_records FROM Retail.sales.brightcoffee;


--Check for duplicates (It must be on a row basis and not just columns)

SELECT *,
COUNT(*)
FROM Retail.sales.brightcoffee
GROUP BY ALL
HAVING COUNT(*) >1;
 -- NO Duplicates found 

--Check for null values 
SELECT *
FROM Retail.sales.brightcoffee
WHERE product_detail IS NULL OR store_location IS NULL OR product_category IS NULL OR product_type IS NULL OR product_detail IS NULL OR unit_price IS NULL OR transaction_id IS NULL OR transaction_time IS NULL OR transaction_date IS NULL OR product_id IS NULL OR transaction_qty IS NULL;
-- no null values 

------------------------------------------------------------------------

--1.TOTAL REVENUE 
SELECT 
SUM(transaction_qty * CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) AS Total_Revenue
FROM retail.sales.brightcoffee;

--2.TOTAL REVENUE PER PRODUCT CATEGORY 
SELECT product_category,
SUM(transaction_qty * CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) AS Total_Revenue
FROM retail.sales.brightcoffee
GROUP BY ALL;

--3. TOTAL REVENUE PER PRODUCT DETAIL AND PRODUCT TYPE
SELECT product_detail,product_type,
SUM(transaction_qty * CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) AS Total_Revenue
FROM retail.sales.brightcoffee
GROUP BY ALL;

--4.TOTAL UNITS SOLD 
SELECT 
SUM(transaction_qty) AS UNITS_SOLD
FROM retail.sales.brightcoffee;

--5.TOTAL REVENUE PER SORE LOCATION
SELECT 
store_location,
SUM(transaction_qty * CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) AS Total_Revenue
FROM retail.sales.brightcoffee
GROUP BY ALL;


--6. TOTAL REVENUE BASED ON THE TIME OF THE DAY 
--earliest transaction time 
SELECT 
MIN(transaction_time),
MAX(transaction_time)
FROM retail.sales.brightcoffee;

--6am - 11;59;59> Morning
--12pm -16:59:59 > Afternoon
--17pm - 19:59:59 > Evening 
--After 20:00 > Night 

SELECT 
CASE
WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
ELSE 'Night'
END AS time_bucket,
SUM(transaction_qty * CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) AS Total_Revenue
FROM retail.sales.brightcoffee
GROUP BY ALL;

--Number of trasaction per time bucket  
SELECT 
CASE 
WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
ELSE 'Night'
END AS time_bucket,
COUNT(transaction_id ) AS Total_Transaction 
FROM retail.sales.brightcoffee
GROUP BY ALL;


--7. Date extraction (Month name, month_id, day name,)
SELECT 
    transaction_date,
    MONTHNAME(transaction_date) AS month_name,
    MONTH(transaction_date) AS month_number,
    DATE_FORMAT(transaction_date,'yyyy-MM') AS month_id,
    DAYNAME(transaction_date) AS day_name,
    DAYOFWEEK(transaction_date) AS day_number
FROM retail.sales.brightcoffee;

--------------------------------------------------

--COMBINE ALL THE CODES

SELECT 
transaction_id,
 transaction_date,
    YEAR(transaction_date) AS year, 
    MONTHNAME(transaction_date) AS month_name,
    MONTH(transaction_date) AS month_number,
    DATE_FORMAT(transaction_date,'yyyy-MMM') AS month_id,
    DAYNAME(transaction_date) AS day_name,
    DAYOFWEEK(transaction_date) AS day_number,
    Product_category,
    Product_type,
    Product_detail,
    store_location,
    transaction_qty,

CASE
WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
ELSE 'Night'
END AS time_bucket,
COUNT(transaction_id ) AS Total_Transaction,
SUM(transaction_qty) as Total_Units_Sold,
SUM(transaction_qty * CAST(REPLACE(unit_price,',','.') AS DECIMAL(10,2))) AS Total_Revenue
FROM retail.sales.brightcoffee
GROUP BY ALL; 
