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

-- 9. List customers in 'Germany' or 'France', ordered by City.

-- 10. Show each product's name, price, and price rounded to the
--     nearest whole dollar, aliased as RoundedPrice.
