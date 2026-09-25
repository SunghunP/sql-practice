USE SqlPractice;
GO

-- ============================================================
-- 02-joins: INNER / LEFT / RIGHT / FULL, self-joins, multi-table
-- ============================================================

-- INNER JOIN

-- 1. List each product's name and its category name.
SELECT p.ProductName, c.CategoryName
FROM dbo.Products p
INNER JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID;

-- 2. List each order's OrderID and OrderDate along with the company
--    name of the customer who placed it.
SELECT o.OrderID, o.OrderDate, c.CompanyName
FROM dbo.Orders o
INNER JOIN dbo.Customers c
ON o.CustomerID = c.CustomerID;

-- 3. List each order's OrderID along with the first and last name of
--    the employee who handled it.
SELECT o.OrderID, e.FirstName, e.LastName
FROM dbo.Orders o
INNER JOIN dbo.Employees e
ON o.EmployeeID = e.EmployeeID;

-- 4. List products in the 'Beverages' category (name + price),
--    cheapest first. (Check Categories for the exact name.)
SELECT p.ProductName, p.UnitPrice
FROM dbo.Products p
INNER JOIN dbo.Categories c
ON p.CategoryID= c.CategoryID
WHERE c.CategoryName = 'Beverages'
ORDER BY p.UnitPrice ASC;

-- LEFT / RIGHT JOIN

-- 5. List every customer's company name and their OrderIDs, including
--    customers who have never placed an order.
SELECT c.CompanyName, o.OrderID
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID;

-- 6. List customers who have never placed an order.
SELECT c.CompanyName
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 7. List products that have never been ordered (name only).
SELECT p.ProductName
FROM dbo.Products p
LEFT JOIN dbo.OrderDetails o
ON p.ProductID = o.ProductID
WHERE o.Quantity IS NULL;

-- 8. List every category and its products, including categories with
--    no products. Rewrite it using RIGHT JOIN.
SELECT c.CategoryName, p.ProductName
FROM dbo.Categories c
LEFT JOIN dbo.Products p
ON c.CategoryID = p.CategoryID;

SELECT c.CategoryName, p.ProductName
FROM dbo.Products p
RIGHT JOIN dbo.Categories c
ON p.CategoryID = c.CategoryID;

-- Multi-table joins

-- 9. For each order line, show OrderID, the customer's company name,
--    the product name, Quantity, and the line's UnitPrice.


-- 10. List the distinct product names that customers in Germany have
--     ordered.


-- 11. Show each order line with its category name and a computed
--     LineTotal (Quantity * UnitPrice), for orders placed in 2021,
--     highest LineTotal first.


-- Self-join

-- 12. List each employee's full name alongside their manager's full
--     name. Include employees with no manager (manager shows NULL).


-- 13. List employees who were hired before their own manager.


-- FULL JOIN / CROSS JOIN

-- 14. Using a FULL JOIN between Customers and Orders, list customers
--     with no orders and orders with no matching customer. (Hint: filter
--     on NULLs from either side. Is the second group even possible?
--     Explain why or why not in a comment.)


-- 15. Produce every combination of Category and Employee title
--     (distinct titles) using a CROSS JOIN.


-- Challenge

-- 16. List the top 5 customers (company name) whose orders have the
--     latest ShippedDate, showing company name, OrderID, and
--     ShippedDate. Exclude unshipped orders.
