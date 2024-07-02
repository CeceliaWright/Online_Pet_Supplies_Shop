/*Online Pet Supplies Shop*/

/*Skills used: Descriptive statistics calculations, advanced aggregations, subqueries and common table expressions (CTEs), data transformation*/
--------------------------------------------------------------------------------------------------------------------------
/*DATA CLEANING*/

	/* changing column data type*/

USE[aliexpress_pet_supplies]
ALTER TABLE aliexpress_pet_supplies
    ALTER COLUMN average_star DECIMAL(3,1);
--------------------------------------------------------------------------------------------------------------------------
	/*Insert unique ID*/

ALTER TABLE aliexpress_pet_supplies
ADD UniqueID INT IDENTITY(1,1);
--------------------------------------------------------------------------------------------------------------------------
	/* Idendifying MEDIAN without incorrect value and imputing invalid value with MEDIAN*/

USE aliexpress_pet_supplies
;WITH ValidValues AS (
    SELECT quantity
    FROM aliexpress_pet_supplies
    WHERE quantity != 15998636
	),
	MedianValue AS (
	SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY quantity) 
	OVER () AS median_quantity
	FROM ValidValues)
SELECT 
    aps.product_title, 
    CASE 
        WHEN aps.quantity = 15998636 THEN (SELECT median_quantity FROM MedianValue)
		ELSE aps.quantity
		END AS imputed_quantity,
    aps.trade_amount_num
FROM 
    aliexpress_pet_supplies aps;
--------------------------------------------------------------------------------------------------------------------------
	/*Performing an UPDATE now that the correctness of the imputed values in the result set is verified*/

;WITH ValidValues AS (
    SELECT quantity
    FROM aliexpress_pet_supplies
    WHERE quantity != 15998636
),
MedianValue AS (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY quantity) OVER () AS median_quantity
    FROM ValidValues
)
UPDATE aps
SET quantity = median_quantity
FROM aliexpress_pet_supplies aps
JOIN MedianValue mv ON aps.UniqueID = 769
WHERE aps.quantity = 15998636;
--------------------------------------------------------------------------------------------------------------------------
	/*correcting trade_amount_num error (Invalid value that suggests true value)*/

UPDATE aliexpress_pet_supplies
SET trade_amount_num = 1000
WHERE UniqueID = 898 
AND product_title = 'Funny Pet Toys Cartoon Cute Plush Bite Resistant Pet Chew Toy for Cats Dogs Interactive Pet Supplies Pet Partner'
AND trade_amount_num = 1;
--------------------------------------------------------------------------------------------------------------------------
/*Basic Descriptive Statistics:*/

	/*Basic Descriptive Statistics at a Glance*/

 SELECT
   	COUNT(*) AS total_products,
   	AVG(average_star) AS avg_rating,
	MIN(quantity) AS min_quantity, 
	MAX(quantity) AS max_quantity,
   	AVG(quantity) AS avg_quantity,
  MIN(trade_amount_num) AS min_amount_sold, 
  MAX(trade_amount_num) AS max_amount_sold,
  SUM(wished_count)as sum_of_wished_count,
   AVG(wished_count) AS average_wished_count,
   MIN(wished_count) AS min_wished_count, 
   MAX(wished_count) AS max_wished_count
   FROM aliexpress_pet_supplies;
--------------------------------------------------------------------------------------------------------------------------
   /*Count of products:** Total number of unique products*/

SELECT COUNT(*) AS Count_of_products  FROM  aliexpress_pet_supplies;

--------------------------------------------------------------------------------------------------------------------------
	/*Mean, median, and mode of average_star*/

SELECT AVG(average_star) AS average_rating FROM aliexpress_pet_supplies;

SELECT DISTINCT PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY average_star) OVER () AS median_rating
FROM aliexpress_pet_supplies;

SELECT TOP 1 average_star as mode_rating
FROM   aliexpress_pet_supplies
GROUP  BY average_star
ORDER  BY COUNT(*) DESC

--------------------------------------------------------------------------------------------------------------------------
   /* Stock analysis:** Mean, median, minimum, minimum, and maximum `quantity`*/

SELECT AVG(quantity) AS average_quantity FROM aliexpress_pet_supplies;

SELECT DISTINCT PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY quantity) OVER () AS median_quantity
FROM aliexpress_pet_supplies;

USE[aliexpress_pet_supplies]
SELECT TOP 1 quantity as mode_quantity
FROM   aliexpress_pet_supplies
GROUP  BY quantity
ORDER  BY COUNT(*) DESC

SELECT MIN(quantity) AS min_quantity, MAX(quantity) AS max_quantity FROM aliexpress_pet_supplies;

SELECT * FROM aliexpress_pet_supplies ORDER BY quantity DESC;
--------------------------------------------------------------------------------------------------------------------------
   /*Sales data: sum, min, max, average, median of `trade_amount_num`*/

USE[aliexpress_pet_supplies]
;WITH Median_CTE AS(
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY trade_amount_num) OVER () AS median_trade_amount_num
FROM 
    aliexpress_pet_supplies
)
SELECT
	SUM(trade_amount_num) AS sum_of_trade_amount_num,
    MIN(trade_amount_num) AS min_trade_amount_num,
    MAX(trade_amount_num) AS max_trade_amount_num,
    AVG(trade_amount_num) AS avg_trade_amount_num,
    (SELECT TOP 1 median_trade_amount_num FROM Median_CTE) AS median_trade_amount_num
FROM 
    aliexpress_pet_supplies;

--------------------------------------------------------------------------------------------------------------------------
	/*Wishlist analysis: Sum, min, max, average, median of `wished_count` */

USE[aliexpress_pet_supplies]
;WITH Median_CTE AS(
SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY wished_count) OVER () AS median_wished_count
FROM 
    aliexpress_pet_supplies
)
SELECT
	SUM(wished_count) AS sum_of_wished_count,
    MIN(wished_count) AS min_wished_count,
    MAX(wished_count) AS max_wished_count,
    AVG(wished_count) AS avg_wished_count,
    (SELECT TOP 1 median_wished_count FROM Median_CTE) AS median_wished_count
FROM 
    aliexpress_pet_supplies;

--------------------------------------------------------------------------------------------------------------------------
/*Market Trend Analysis*/
	/*Identify Top 10 Selling Products*/
USE[aliexpress_pet_supplies]
SELECT TOP 10 product_title, trade_amount, trade_amount_num, category, average_star,  wished_count FROM aliexpress_pet_supplies
ORDER BY trade_amount_num DESC, product_title;

USE[aliexpress_pet_supplies]
SELECT COUNT(product_title)
FROM aliexpress_pet_supplies
WHERE trade_amount_num = 0;


SELECT COUNT(product_title) AS 'products selling 10,000 +'
FROM aliexpress_pet_supplies
WHERE trade_amount_num = 10000;

--------------------------------------------------------------------------------------------------------------------------
	/*Top 10 Products by Wishlist*/
		/* Products with the highest `wishedCount` and average ratings of the most wished-for products.*/

SELECT TOP 10 product_title, wished_count, average_star, trade_amount,  category FROM aliexpress_pet_supplies
ORDER BY wished_count DESC;

--------------------------------------------------------------------------------------------------------------------------
	/*Sales distribution: Distribution of sales across different products*/

 USE[aliexpress_pet_supplies]
;WITH total_productsCTE AS (
SELECT COUNT(*) AS total_count
FROM aliexpress_pet_supplies
),
subquery AS
   (SELECT 
        CASE 
            WHEN trade_amount_num BETWEEN 0 AND 499 THEN '0-499'
            WHEN trade_amount_num BETWEEN 500 AND 999 THEN '500-999'
            WHEN trade_amount_num BETWEEN 1000 AND 4999 THEN '1000-4999'
            WHEN trade_amount_num >= 5000 THEN '5000+'
            ELSE 'Unknown'
        END AS trade_amount_bin,
        trade_amount_num
    FROM 
        aliexpress_pet_supplies
    )
SELECT 
    subquery.trade_amount_bin,
    COUNT(*) AS count_of_products,
	CAST(COUNT(*) * 100 / total_productsCTE.total_count AS DECIMAL (7,2)) AS percent_of_total
FROM 
   subquery
CROSS JOIN 
    total_productsCTE
GROUP BY 
    subquery.trade_amount_bin, total_productsCTE.total_count
ORDER BY 
    CASE 
        WHEN trade_amount_bin = '0-499' THEN 1
        WHEN trade_amount_bin = '500-999' THEN 2
        WHEN trade_amount_bin = '1000-4999' THEN 3
        WHEN trade_amount_bin = '5000+' THEN 4
        ELSE 5
    END;

 --------------------------------------------------------------------------------------------------------------------------
	/*Wishlist distribution: Distribution of wishlist counts across different products*/
 
  SELECT wished_count_bin,
    COUNT(*) AS count_of_products
FROM ( SELECT
    CASE 
        WHEN wished_count = 0 THEN '0'
        WHEN wished_count BETWEEN 1 AND 10 THEN '1-10'
        WHEN wished_count BETWEEN 11 AND 50 THEN '11-50'
        WHEN wished_count BETWEEN 51 AND 100 THEN '51-100'
        WHEN wished_count BETWEEN 101 AND 500 THEN '101-500'
        WHEN wished_count BETWEEN 501 AND 1000 THEN '501-1000'
        WHEN wished_count BETWEEN 1001 AND 5000 THEN '1001-5000'
        WHEN wished_count BETWEEN 5001 AND 10000 THEN '5001-10000'
        ELSE '10001+'
    END AS wished_count_bin,
    CASE 
            WHEN wished_count = 0 THEN 1
            WHEN wished_count BETWEEN 1 AND 10 THEN 2
            WHEN wished_count BETWEEN 11 AND 50 THEN 3
            WHEN wished_count BETWEEN 51 AND 100 THEN 4
            WHEN wished_count BETWEEN 101 AND 500 THEN 5
            WHEN wished_count BETWEEN 501 AND 1000 THEN 6
            WHEN wished_count BETWEEN 1001 AND 5000 THEN 7
            WHEN wished_count BETWEEN 5001 AND 10000 THEN 8
            ELSE 9
        END AS wished_count_order
    FROM 
        aliexpress_pet_supplies
    ) AS subquery
	GROUP BY 
    wished_count_bin, wished_count_order
ORDER BY 
    wished_count_order;

--------------------------------------------------------------------------------------------------------------------------
 /*Product Rating Analysis*/

	/*Rating Distribution: Distribution of products across ratings*/

USE [aliexpress_pet_supplies]
   SELECT CASE 
   WHEN average_star = 0 THEN 0
   WHEN average_star >= 1 AND average_star < 2 THEN 1
   WHEN average_star >= 2 AND average_star < 3 THEN 2
   WHEN average_star >= 3 AND average_star < 4 THEN 3
   WHEN average_star >= 4 AND average_star < 5 THEN 4
   WHEN average_star = 5 THEN 5
END AS rating_group,
COUNT(product_title) as count_of_product
FROM aliexpress_pet_supplies
GROUP BY 
	CASE
	 WHEN average_star = 0 THEN 0
	WHEN average_star >= 1 AND average_star < 2 THEN 1
   WHEN average_star >= 2 AND average_star < 3 THEN 2
   WHEN average_star >= 3 AND average_star < 4 THEN 3
   WHEN average_star >= 4 AND average_star < 5 THEN 4
   WHEN average_star = 5 THEN 5
END
ORDER BY rating_group;
 
 --------------------------------------------------------------------------------------------------------------------------
   /* Top-rated products: Products with the highest average ratings*/
	/* There are 427 products with a ratin of 5.0, top 10 alone does not provide meaningful insight */

SELECT COUNT(product_title)as product_title, average_star AS average_rating
from aliexpress_pet_supplies
WHERE average_star = 5.0
group by average_star;

SELECT TOP 10 product_title, trade_amount, category, average_star,  wished_count FROM aliexpress_pet_supplies
ORDER BY average_star DESC;

    /*Lowest-rated products: Products with the lowest average ratings*/
		/* There are 229 products with a rating of 0.0 */

		SELECT COUNT(product_title)as product_title, average_star AS average_rating
from aliexpress_pet_supplies
WHERE average_star = 0
group by average_star;

--------------------------------------------------------------------------------------------------------------------------
/*Inventory Management*/
   /*Stock levels:** Products with the highest and lowest `quantity`*/

   SELECT TOP 10 product_title, quantity, trade_amount, category, average_star,  wished_count FROM aliexpress_pet_supplies
ORDER BY quantity DESC;

   SELECT TOP 10 product_title, quantity, trade_amount, category, average_star,  wished_count FROM aliexpress_pet_supplies
ORDER BY quantity;

--------------------------------------------------------------------------------------------------------------------------
	/*Stock optimization: Identify products with high stock but low sales for inventory optimization.*/ 

USE[aliexpress_pet_supplies]
SELECT product_title, 
	category, 
	quantity, 
	trade_amount_num AS sales,
	(quantity/NULLIF(trade_amount_num, 0)) AS stock_to_sales_ratio
FROM 
	aliexpress_pet_supplies
WHERE 
	trade_amount_num < 50 
    AND quantity > 1000      
ORDER BY stock_to_sales_ratio DESC;
--------------------------------------------------------------------------------------------------------------------------
	/*Identify Products with High Stock but Low Sales*/

  SELECT 
  product_title,
   	category,
   	quantity,
   	trade_amount_num AS sales
   FROM
   	aliexpress_pet_supplies
   WHERE
   	trade_amount_num < 50 
   	AND quantity > 1000   	
   ORDER BY
   	quantity DESC;
--------------------------------------------------------------------------------------------------------------------------
	/*Calculate Total Quantity in Stock and Total Sales for Each Category*/

   SELECT
   	category,
   	SUM(quantity) AS total_quantity_in_stock,
   	SUM(trade_amount_num) AS total_sales
   FROM
   	aliexpress_pet_supplies
   GROUP BY
   	category;
--------------------------------------------------------------------------------------------------------------------------
	/*average sales per product*/
	
	SELECT 
    AVG(trade_amount_num) AS avg_sales_per_product
FROM 
    aliexpress_pet_supplies;
--------------------------------------------------------------------------------------------------------------------------
	/*Calculate optimal stock levels based on sales data.*/
		/*Assume company wants to maintain a stock level that covers 3 times the average sales per product*/

;WITH average_salesCTE  AS (
	SELECT AVG(trade_amount_num) as average_sales_per_product
	FROM aliexpress_pet_supplies
	),
	product_dataCTE AS (
    SELECT 
        product_title,
        category,
        quantity,
        trade_amount_num AS sales,
        (quantity / NULLIF(trade_amount_num, 0)) AS stock_to_sales_ratio
    FROM 
        aliexpress_pet_supplies
		)
SELECT
	product_title,
	category,
    quantity,
	stock_to_sales_ratio,
	(3*average_salesCTE.average_sales_per_product) AS optimal_stock_level,
		CASE 
		WHEN quantity > (3*average_salesCTE.average_sales_per_product) THEN 'overstocked'
		WHEN quantity < (3*average_salesCTE.average_sales_per_product) THEN 'understocked'
		ELSE 'optimal_stock_level'
 END AS stock_status
FROM product_dataCTE, average_salesCTE
ORDER BY 
    stock_to_sales_ratio DESC;
--------------------------------------------------------------------------------------------------------------------------
	/*count and percentage of items that are understocked, overstocked, etc.*/

USE[aliexpress_pet_supplies]
;WITH sales_statsCTE  AS (
   SELECT
	CAST(AVG(CAST(trade_amount_num AS DECIMAL(18, 10))) AS DECIMAL(18, 10)) AS average_sales_per_product, 
	stdev(trade_amount_num) AS stdev_sales_per_product
    FROM aliexpress_pet_supplies
    ),
    product_dataCTE AS (
	SELECT
    	product_title,
    	category,
    	quantity,
    	trade_amount_num AS sales,
    	(quantity / NULLIF(trade_amount_num, 0)) AS stock_to_sales_ratio
	FROM
    	aliexpress_pet_supplies
   	 ),
optimal_stock_levelCTE AS(
SELECT
    product_title,
    category,
	quantity,
    stock_to_sales_ratio,
    sales_statsCTE.average_sales_per_product,
     sales_statsCTE.stdev_sales_per_product,
   	 CASE
	 WHEN quantity > ((3*sales_statsCTE.average_sales_per_product) + sales_statsCTE.stdev_sales_per_product ) THEN 'overstocked'
   	 WHEN quantity < ((3*sales_statsCTE.average_sales_per_product)  - sales_statSCTE.stdev_sales_per_product) THEN 'understocked'
   	 ELSE 'optimal_stock_level'
 END AS stock_status
FROM product_dataCTE, sales_statsCTE
),
stock_countsCTE AS ( 
	SELECT stock_status, COUNT(*) AS product_count
	FROM 
	optimal_stock_levelCTE
	GROUP BY stock_status
),
total_countCTE AS(
	SELECT SUM(product_count) AS total_products
	FROM stock_countsCTE
)
SELECT 
    sc.stock_status, 
    sc.product_count,
    CAST((sc.product_count * 100.0 / tc.total_products) AS DECIMAL (8,2)) AS percentage_of_total
FROM 
    stock_countsCTE sc, 
    total_countCTE tc
ORDER BY 
    sc.product_count DESC;
	

USE[aliexpress_pet_supplies]
SELECT AVG(trade_amount_num)
from aliexpress_pet_supplies;

--------------------------------------------------------------------------------------------------------------------------
/*troubleshooting tableau*/

USE[aliexpress_pet_supplies]
SELECT AVG(trade_amount_num) AS average_sales_per_product,
       STDEV(trade_amount_num) AS stdev_sales_per_product
FROM aliexpress_pet_supplies;

SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN trade_amount_num IS NULL THEN 1 ELSE 0 END) AS null_count,
    SUM(CASE WHEN trade_amount_num = 0 THEN 1 ELSE 0 END) AS zero_count,
    AVG(trade_amount_num) AS average_sales_per_product
FROM 
    aliexpress_pet_supplies;

	SELECT 
    CAST(AVG(CAST(trade_amount_num AS DECIMAL(18, 10))) AS DECIMAL(18, 10)) AS average_sales_per_product 
FROM 
    aliexpress_pet_supplies;

	SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE 
FROM 
    INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_NAME = 'aliexpress_pet_supplies' 
    AND COLUMN_NAME = 'trade_amount_num';

