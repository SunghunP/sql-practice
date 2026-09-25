USE SqlPractice;
GO

-- ============================================================
-- 03-aggregation-grouping: GROUP BY, HAVING, aggregate functions
-- ============================================================

-- Basic aggregates

-- 1. How many customers are there? How many distinct countries?
SELECT 
	COUNT(c.CustomerID) AS CustomerCount,
	COUNT(DISTINCT c.Country) AS CountryCount
FROM dbo.Customers c;

-- 2. Show the lowest, highest, and average UnitPrice across all
--    products (average rounded to 2 decimals).
SELECT 
	MIN(p.UnitPrice) AS MinPrice,
	MAX(p.UnitPrice) AS MaxPrice,
	AVG(p.UnitPrice) AS AvgPrice
FROM dbo.Products p;

-- 3. How many orders have not shipped yet?
SELECT COUNT(*) AS NotShipped
FROM dbo.Orders o
WHERE o.ShippedDate IS NULL;

-- 4. What is the total revenue across all order lines
--    (SUM of Quantity * UnitPrice)?
SELECT SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
FROM dbo.OrderDetails od;

-- GROUP BY

-- 5. Show the number of customers per country, most customers first.
SELECT 
	c.Country, 
	COUNT(c.CustomerID) AS NumberOfCustomers
FROM dbo.Customers c
GROUP BY c.Country
ORDER BY NumberOfCustomers DESC;

-- 6. Show the number of products per category (category name + count).
SELECT 
	c.CategoryName, 
	COUNT(p.ProductID) AS ProductCount
FROM dbo.Categories c
LEFT JOIN dbo.Products p
ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;

-- 7. Show the number of orders per year (by OrderDate), oldest year first.
SELECT 
	DATEPART(YEAR, o.OrderDate) AS OrderYear, 
	COUNT(o.OrderID) AS OrderCount
FROM dbo.Orders o
GROUP BY DATEPART(YEAR, o.OrderDate)
ORDER BY DATEPART(YEAR, o.OrderDate) ASC;

-- 8. Show total revenue per product (product name + revenue),
--    highest first.
SELECT
	p.ProductID,
	p.ProductName,
	SUM(od.Quantity * od.UnitPrice) AS Revenue
FROM dbo.Products p
INNER JOIN dbo.OrderDetails od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Revenue DESC;

-- 9. Show the number of orders handled per employee (full name + count),
--    including employees with zero orders.
SELECT 
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName as FullName,
	COUNT(o.OrderID) AS HandledOrders
FROM dbo.Employees e
LEFT JOIN dbo.Orders o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- HAVING

-- 10. List countries with more than 5 customers.
SELECT c.Country
FROM dbo.Customers c
GROUP BY c.Country
HAVING COUNT(c.CustomerID) > 5;

-- 11. List products that have been ordered in total quantity of more
--     than 100 units.
SELECT 
	p.ProductName,
	SUM(od.Quantity) AS QuantityOrdered
FROM dbo.Products p
LEFT JOIN dbo.OrderDetails od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 100;

-- 12. List categories whose average product UnitPrice is above 30.


-- WHERE vs HAVING

-- 13. Show revenue per customer (company name) counting only orders
--     placed in 2021, and only customers whose 2021 revenue exceeds
--     5000. Highest first.


-- 14. For non-discontinued products only, show the number of products
--     and the average price per category, keeping categories with at
--     least 3 such products.


-- Multi-level grouping

-- 15. Show revenue per year and per category (year, category name,
--     revenue), ordered by year then revenue descending.


-- 16. Show how many distinct customers ordered in each country per
--     year. (Hint: COUNT(DISTINCT ...).)


-- Challenge

-- 17. Find the average number of order lines per order.
--     (Hint: you need two levels of aggregation. A subquery in FROM is
--     allowed, or peek ahead at 05.)


-- 18. List employees whose total revenue handled is above the average
--     revenue per employee. (Hint: needs a subquery or CTE.)
