/* ============================================================
   01 — Fundamentals: SELECT, WHERE, ORDER BY, DISTINCT, TOP
   Run datasets/setup/create_and_seed.sql first.
   USE SqlPractice; before running these.
   ============================================================ */

-- 1. List all products with their name and unit price.
SELECT p.ProductName, p.UnitPrice
FROM dbo.Products p;
-- 2. List all customers located in 'USA'.
SELECT *
FROM dbo.Customers c
WHERE c.Country = 'USA';

-- 3. List products with a UnitPrice greater than 20, ordered from
--    most expensive to cheapest.
SELECT *
FROM dbo.Products p
WHERE p.UnitPrice > 20
ORDER BY p.UnitPrice DESC;

-- 4. List the distinct countries that customers are located in.
SELECT DISTINCT c.Country
FROM dbo.Customers c;

-- 5. Find the 5 cheapest products (name + price).
SELECT TOP 5 p.ProductName, p.UnitPrice
FROM dbo.Products p
ORDER BY p.UnitPrice ASC;

-- 6. List employees hired after 2019-01-01, showing first name,
--    last name, and hire date.
SELECT e.FirstName, e.LastName, e.HireDate
FROM dbo.Employees e
WHERE e.HireDate > '2019-01-01';

-- 7. List products whose name contains the word 'Set'.
SELECT p.ProductName
FROM dbo.Products p
WHERE p.ProductName LIKE '%Set%';

-- 8. List orders that have never shipped (ShippedDate IS NULL).
SELECT * 
FROM dbo.Orders o
WHERE o.ShippedDate IS NULL;

-- 9. List customers in 'Germany' or 'France', ordered by City.
SELECT *
FROM dbo.Customers c
WHERE c.Country = 'Germany' OR c.Country = 'France'
ORDER BY c.Country;

SELECT *
FROM dbo.Customers c
WHERE c.Country IN ('Germany', 'France')
ORDER BY c.Country;

-- 10. Show each product's name, price, and price rounded to the
--     nearest whole dollar, aliased as RoundedPrice.
SELECT 
	p.ProductName, 
	p.UnitPrice,
	CAST(ROUND(p.UnitPrice, 0)AS INT) AS RoundedPrice
FROM dbo.Products p;

-- ============================================================
-- Challenge questions (combine everything from 01-fundamentals)
-- ============================================================

-- C1. List the 3 most expensive products whose name contains 'Set'
--     or 'Kit', with a price of at least 10. Show the name, the price,
--     and the price rounded to a whole-dollar INT as RoundedPrice.
--     Break ties by name A-Z.
SELECT TOP 3
	p.ProductName,
	p.UnitPrice,
	CAST(ROUND(p.UnitPrice, 0) AS INT) AS RoundedPrice
FROM dbo.Products p
WHERE 
	(p.ProductName LIKE '%SET%' OR p.ProductName LIKE '%Kit%') AND
	p.UnitPrice >= 10
ORDER BY p.UnitPrice DESC, p.ProductName;

-- C2. List the distinct cities of customers in Germany, France, or
--     the UK, excluding cities that start with 'B'. Sort by country,
--     then city, and return only the first 10 rows.
SELECT DISTINCT TOP 10 C.City, C.Country
FROM dbo.Customers c
WHERE 
	c.Country IN ('Germany', 'France', 'UK') AND
	c.City NOT LIKE 'B%'
ORDER BY  c.Country, C.City;

-- C3a. List orders that have not shipped yet and were placed before
--      2020-01-01. Show all columns, oldest first.
SELECT *
FROM dbo.Orders o
WHERE 
	o.ShippedDate IS NULL AND
	o.OrderDate < '2020-01-01'
ORDER BY o.OrderDate ASC;

-- C3b. List the 5 most recently hired employees who were hired after
--      2019-01-01. Show FullName (first + last name joined with a
--      space) and the hire date, newest first.


