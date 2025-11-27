-- ============================================
-- 1. Check for missing/null values in the table
-- ============================================
SELECT *
FROM zepto
WHERE name IS NULL
   OR Category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR availableQuantity IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;


-- ============================================
-- 2. Distinct product categories
-- ============================================
SELECT DISTINCT Category
FROM zepto
ORDER BY Category;


-- ============================================
-- 3. Products in stock vs out of stock
-- ============================================
SELECT outOfStock, COUNT(sku_id) AS count
FROM zepto
GROUP BY outOfStock;


-- ============================================
-- 4. Product names present multiple times
-- ============================================
SELECT name, COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


-- ============================================
-- 5. Data cleaning
-- ============================================

-- 5a. Products with price = 0
SELECT *
FROM zepto
WHERE mrp = 0
   OR discountedSellingPrice = 0;

-- Delete products with MRP = 0
DELETE FROM zepto
WHERE mrp = 0;

-- 5b. Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Verify conversion
SELECT mrp, discountedSellingPrice
FROM zepto;


-- ============================================
-- 6. Analysis Queries
-- ============================================

-- Q1: Top 10 best value products based on discount percentage
SELECT DISTINCT TOP 10 name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC;


-- Q2: Products with high MRP but out of stock
SELECT name, mrp
FROM zepto
WHERE outOfStock = 1
  AND mrp > 300
ORDER BY mrp DESC;


-- Q3: Estimated revenue per category
SELECT Category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY Category;


-- Q4: Products with MRP > 500 and discount < 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500
  AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;


-- Q5: Top 5 categories offering highest average discount
SELECT TOP 5 Category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY Category
ORDER BY avg_discount DESC;


-- Q6: Price per gram for products above 100g
SELECT DISTINCT name, weightInGms, discountedSellingPrice, 
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;


-- Q7: Categorize products by weight
SELECT DISTINCT name, weightInGms,
       CASE 
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;


-- Q8: Total inventory weight per category
SELECT Category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY Category
ORDER BY total_weight DESC;
