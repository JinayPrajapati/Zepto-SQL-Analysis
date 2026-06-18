CREATE DATABASE Zepto_SQL_Project;

-- create table
CREATE TABLE zepto(
category varchar(120),
name varchar(150),
mrp numeric(8,2),
discountPercent numeric(8,2),
availableQuantity int,
discountedSellingPrice numeric(8,2),
weightInGms int,
outOfStock bool,
quantity int
);

drop table zepto; 

-- data exploration start

-- All data
select * from zepto;

-- count of rows
SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto
LIMIT 10;

-- null values
SELECT * FROM zepto
WHERE category IS NULL
OR 
name IS NULL
OR 
mrp IS NULL
OR 
discountPercent IS NULL
OR 
availableQuantity IS NULL
OR 
discountedSellingPrice IS NULL
OR 
weightInGms IS NULL
OR 
outOfStock IS NULL
OR 
quantity IS NULL;

-- different product categories
SELECT DISTINCT category
FROM
zepto;

-- product in stock vs out of stock
SELECT outOfStock, count(*)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
SELECT name, COUNT(*)
FROM zepto
GROUP BY name
HAVING count(*) > 1
ORDER BY count(*) desc;

-- data exploration ends

-- data cleaning starts

-- products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

-- converting paise to rupees
UPDATE zepto
SET mrp = mrp/100.0, discountedSellingPrice = discountedSellingPrice/100.0;

-- data cleaning ends

-- business insights

-- 1. Find the top 10 best-value products based on the discounted percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- 2.What are the Products with High Mrp but Out Of Stock.
SELECT DISTINCT name , mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 250
ORDER BY mrp DESC;

-- 3.Calculate Estimated Revenue for each category.
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- 4.Find all products where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name , mrp , discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC , discountPercent DESC;

-- 5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category ,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- 6. Find the price per gram for products above 100g and sort by best values.
SELECT DISTINCT name , weightInGms , discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- 7.Group the products into category like Low , Medium , Bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 700 THEN 'Low'
	WHEN weightInGms < 4000 THEN 'Medium'
    ELSE 'Bulk'
    END AS weight_category
FROM zepto;    

-- 8.What is the total inventory weight per category
SELECT category,
SUM(weightInGms*availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
