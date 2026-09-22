/* ============================================================
   01 — Fundamentals: Solutions
   Try exercises.sql yourself first.
   ============================================================ */

USE SqlPractice;
GO

-- 1.
SELECT ProductName, UnitPrice FROM Products;

-- 2.
SELECT * FROM Customers WHERE Country = 'USA';

-- 3.
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC;

-- 4.
SELECT DISTINCT Country FROM Customers;

-- 5.
SELECT TOP 5 ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice ASC;

-- 6.
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE HireDate > '2019-01-01';

-- 7.
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%Set%';

-- 8.
SELECT *
FROM Orders
WHERE ShippedDate IS NULL;

-- 9.
SELECT *
FROM Customers
WHERE Country IN ('Germany', 'France')
ORDER BY City;

-- 10.
SELECT ProductName, UnitPrice, ROUND(UnitPrice, 0) AS RoundedPrice
FROM Products;
