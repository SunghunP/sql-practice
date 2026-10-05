USE SqlPractice;
GO

-- ============================================================
-- 05-cte-subqueries: CTEs, correlated subqueries, recursive CTEs
-- ============================================================

-- Scalar and IN subqueries

-- 1. List products priced above the average UnitPrice of all products.
-- Scalar
SELECT
	ProductName,
	UnitPrice
FROM dbo.Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM dbo.Products);

-- Window Function and CTE
WITH HigherProduct AS (
	SELECT
		ProductName,
		UnitPrice,
		AVG(UnitPrice) OVER () AS AvgPrice
	FROM dbo.Products
)

SELECT
	ProductName,
	UnitPrice
FROM HigherProduct
WHERE(UnitPrice > AvgPrice)

-- 2. List the orders placed on the most recent OrderDate in the table.
SELECT
  OrderID,
  OrderDate
FROM dbo.Orders
WHERE OrderDate = (SELECT MAX(OrderDate) FROM dbo.Orders);

-- 3. List products that have been ordered with a Quantity of 50 or more
--    on any order line (use IN with a subquery on OrderDetails).
SELECT
  p.ProductName,
  p.ProductID
FROM dbo.Products p
WHERE p.ProductID IN (
  SELECT od.ProductID
  FROM dbo.OrderDetails od
  WHERE od.Quantity >= 50
);

-- 4. List customers who have placed at least one order
--    (use IN with a subquery, then rewrite with EXISTS).
SELECT
  CustomerID,
  CompanyName
FROM dbo.Customers 
WHERE CustomerID IN (SELECT CustomerID FROM dbo.Orders);

SELECT 
  c.CustomerID, 
  c.CompanyName
FROM dbo.Customers c
WHERE EXISTS (
  SELECT 1
  FROM dbo.Orders o
  WHERE o.CustomerID = c.CustomerID
);

-- 5. List employees who have handled at least one order
--    (use IN with a subquery, then rewrite with EXISTS).
SELECT
  EmployeeID,
  FirstName + ' ' + LastName AS EmployeeName
FROM dbo.Employees
WHERE EmployeeID IN (SELECT EmployeeID FROM dbo.Orders);

SELECT
  EmployeeID,
  (FirstName + ' ' + LastName) AS EmployeeName
FROM dbo.Employees e
WHERE EXISTS (
  SELECT 1
  FROM dbo.Orders o
  WHERE o.EmployeeID = e.EmployeeID
);

-- 6. List customers who have never placed an order, using NOT EXISTS.
--    Why is NOT IN risky here if the subquery can return NULLs?
SELECT 
  c.CustomerID, 
  c.CompanyName
FROM dbo.Customers c
WHERE NOT EXISTS (
  SELECT 1
  FROM dbo.Orders o
  WHERE o.CustomerID = c.CustomerID
);
-- NOT IN is risky: if the subquery returns any NULL, every comparison
-- becomes UNKNOWN and the query returns zero rows. NOT EXISTS is safe
-- because NULLs never satisfy the = correlation.

-- Returns no rows if any Orders.CustomerID is NULL
SELECT CustomerID, CompanyName
FROM dbo.Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM dbo.Orders);

-- 7. List products that appear in at least one order placed in 2021.
SELECT
  p.ProductName,
  p.ProductID
FROM dbo.Products p
WHERE p.ProductID IN (
  SELECT od.ProductID
  FROM dbo.OrderDetails od
  JOIN dbo.Orders o
  ON od.OrderID = o.OrderID
  WHERE o.OrderDate >= '2021-01-01' AND o.OrderDate < '2022-01-01'
);

-- Subqueries in FROM / SELECT

-- 8. Show each product's name, price, and the average price of its
--    category via a scalar subquery in the SELECT list.
SELECT
  p.ProductName,
  p.UnitPrice,
  (SELECT AVG(p2.UnitPrice)
   FROM dbo.Products p2
   WHERE p2.CategoryID = p.CategoryID) AS CategoryAvgPrice
FROM dbo.Products p;

-- 9. Using a subquery in FROM, show the average number of order lines
--    per order.


-- Correlated subqueries

-- 10. For each customer, show the date of their most recent order
--    using a correlated subquery.


-- 11. List products that cost more than the average price of their
--    own category.


-- 12. List orders whose total value is higher than the average total
--    value of all orders placed by the same customer.


-- CTEs

-- 13. Rewrite #9 with a CTE.


-- 14. Using a CTE, list the top 5 customers by total revenue
--     (company name + revenue).


-- 15. Using two chained CTEs: first compute revenue per order, then
--     per customer average order revenue. Show customers whose average
--     is above the overall average.


-- 16. Using a CTE, find employees who handled more orders than the
--     average employee.


-- Recursive CTEs

-- 17. Generate the numbers 1 through 20 with a recursive CTE.


-- 18. Show the full employee hierarchy: each employee with their
--     level (top manager = 0) and the chain of manager names as a
--     string (e.g. 'Smith > Jones > Lee').


-- 19. For a given manager (pick one), list every direct and indirect
--     report.


-- 20. Generate every date in 2021 with a recursive CTE, then LEFT JOIN
--     to Orders to show the number of orders per day, including days
--     with zero orders.


-- Challenge

-- 21. Find the product pairs most often bought together in the same
--     order (product A name, product B name, times together).
--     Avoid duplicates like (A,B) and (B,A).


-- 22. For each category, find the product with the highest total
--     revenue. Do it two ways: with a correlated subquery and with a
--     CTE. Compare the results.

