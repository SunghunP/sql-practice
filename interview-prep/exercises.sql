USE SqlPractice;
GO


-- ============================================================
-- 03-aggregation-grouping: GROUP BY, HAVING, aggregate functions
-- ============================================================

-- Challenge

-- 17. Find the average number of order lines per order.
--     (Hint: you need two levels of aggregation. A subquery in FROM is
--     allowed, or peek ahead at 05.)

WITH OrderCount AS (
  SELECT
    OrderID,
    COUNT(*) AS LineCount
  FROM dbo.OrderDetails
  GROUP BY OrderID
)

SELECT
  AVG(LineCount * 1.0) AS AvgLinesPerOrder
FROM OrderCount

-- 18. List employees whose total revenue handled is above the average
--     revenue per employee. (Hint: needs a subquery or CTE.)

WITH EmployeeTotals AS (
  SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
  FROM dbo.Employees e
  INNER JOIN dbo.Orders o
    ON e.EmployeeID = o.EmployeeID
  INNER JOIN dbo.OrderDetails od
    ON o.OrderID = od.OrderID
  GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
)

SELECT
  EmployeeID,
  FirstName,
  LastName,
  TotalRevenue
FROM EmployeeTotals
WHERE TotalRevenue > (SELECT AVG(TotalRevenue) FROM EmployeeTotals);


-- ============================================================
-- 04-window-functions: ROW_NUMBER, RANK, PARTITION BY, running totals
-- ============================================================

-- Challenge

-- 16. Find customers whose most recent order is more than 90 days
--     older than the latest OrderDate in the whole table.


-- 17. For each employee, show their best month by revenue
--     (employee full name, month, revenue). Ties: pick the earlier
--     month.


-- 18. Identify "gaps and islands": for each customer, group
--     consecutive-month ordering streaks and return the longest streak
--     length per customer.


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

-- 9. Using a subquery in FROM, show the average number of orders per
--    customer.
SELECT
  AVG(CustomerOrderCount) AS AvgOrdersPerCustomer
FROM (
  SELECT
    CustomerID,
    COUNT(OrderID) AS CustomerOrderCount
  FROM dbo.Orders
  GROUP BY CustomerID
) AS CustomerOrderCounts

-- Correlated subqueries

-- 10. For each customer, show the date of their most recent order
--    using a correlated subquery.
SELECT
  c.CustomerID,
  (SELECT MAX(o.OrderDate)
   FROM dbo.Orders o
   WHERE o.CustomerID = c.CustomerID) AS MostRecentOrder
FROM dbo.Customers c;

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


-- ============================================================
-- 06-date-time: date math, DATEDIFF/DATEADD, formatting
-- ============================================================

-- Extracting parts

-- 1. Show each order's OrderID, year, month, and day of week name
--    (use YEAR, MONTH, DATENAME).


-- 2. List orders placed on a weekend. (Careful: DATEPART(WEEKDAY, ...)
--    depends on DATEFIRST. Use DATENAME or check @@DATEFIRST.)


-- 3. Show the quarter each order was placed in and the number of
--    orders per quarter.


-- DATEDIFF / DATEADD

-- 4. For shipped orders, show OrderID and the number of days between
--    OrderDate and ShippedDate.


-- 5. List orders that took more than 7 days to ship.


-- 6. Show each employee's full name and tenure in whole years as of
--    today. Note: DATEDIFF(YEAR, ...) counts calendar boundaries, so
--    it can be off by one. Write an accurate version.


-- 7. For each order, show a "due date" 14 days after OrderDate.


-- 8. List orders that are unshipped and were placed more than 30 days
--    before the latest OrderDate in the table.


-- Truncating and boundaries

-- 9. Show the first day of the month for each OrderDate, and the number
--    of orders per month. (Hint: DATEFROMPARTS or EOMONTH tricks.)


-- 10. List orders placed in the last full calendar month of the data
--     (relative to MAX(OrderDate)), without hard-coding dates.


-- 11. Show the last day of the month for each employee's HireDate
--     using EOMONTH.


-- Formatting

-- 12. Show each OrderDate formatted as 'Mon DD, YYYY' (e.g. 'Mar 05,
--     2021') using FORMAT, and again using CONVERT with a style.
--     Which is faster on large tables and why?


-- 13. Show monthly order counts labelled as 'YYYY-MM'.


-- Analysis

-- 14. Find the month with the most orders in each year.


-- 15. Show the average days-to-ship per month, for shipped orders only,
--     rounded to 1 decimal.


-- 16. For each customer, show the average number of days between
--     consecutive orders. (Hint: LAG from 04.)


-- Challenge

-- 17. Produce a calendar table of every date between the earliest
--     and latest OrderDate with columns: date, year, month, day name,
--     is_weekend, and the number of orders placed that day.


-- 18. Find the longest streak of consecutive days with at least one
--     order, and its start and end dates.


-- ============================================================
-- 07-performance: execution plans, indexing, query tuning
-- Tip: in SSMS turn on Include Actual Execution Plan (Ctrl+M) and
-- run SET STATISTICS IO, TIME ON; before each exercise.
-- ============================================================

-- Reading plans

-- 1. Run SELECT * FROM dbo.Orders WHERE CustomerID = 10 and read the
--    plan. What operator does it use to find the rows? Write your
--    answer in a comment.


-- 2. Run the same query selecting only OrderID and CustomerID. Does
--    the plan or the logical reads change? Why?


-- 3. Compare logical reads for a query filtering on OrderDate vs. one
--    filtering on OrderID. Explain the difference.


-- Indexes

-- 4. Create a nonclustered index on Orders(CustomerID). Re-run #1 and
--    compare the plan and logical reads. Explain the new operators
--    (Index Seek + Key Lookup).


-- 5. Turn the index from #4 into a covering index using INCLUDE so the
--    Key Lookup disappears for the query in #2.


-- 6. Create an index to speed up: WHERE ShippedDate IS NULL. Consider a
--    filtered index. When is a filtered index a good idea?


-- 7. Build a composite index for
--    WHERE CustomerID = @c AND OrderDate >= @d ORDER BY OrderDate.
--    Does column order in the index matter? Test both orders.


-- SARGability

-- 8. This query can't use an index seek on OrderDate. Rewrite it:
--      WHERE YEAR(OrderDate) = 2021
--    Compare the plans.


-- 9. Rewrite this to be SARGable and explain why the original is not:
--      WHERE DATEADD(DAY, 7, OrderDate) > '2021-06-01'


-- 10. Compare LIKE 'Ger%' vs. LIKE '%many' on Customers.Country (after
--     indexing it). Why does one seek and the other scan?


-- 11. Explain what happens when you compare a VARCHAR column to an
--     NVARCHAR literal (N'Germany'). Check for implicit conversion
--     warnings in the plan.


-- Query rewrites

-- 12. Rewrite this NOT IN query with NOT EXISTS and compare the plans:
--       SELECT * FROM dbo.Customers
--       WHERE CustomerID NOT IN (SELECT CustomerID FROM dbo.Orders)


-- 13. Compare COUNT(*) vs. EXISTS for checking "does this customer
--     have any orders". Which does less work?


-- 14. Compare a correlated subquery vs. a JOIN + GROUP BY for "latest
--     order per customer" vs. ROW_NUMBER. Record reads and duration
--     for all three.


-- 15. Show how SELECT * vs. selecting specific columns affects reads
--     when a covering index exists.


-- Join strategies and stats

-- 16. Force each join type on a join of Orders and OrderDetails using
--     query hints (LOOP, HASH, MERGE). Compare cost and reads. Do not
--     leave hints in production code. Why?


-- 17. Update statistics on Orders, then find the estimated vs. actual
--     row counts in a plan. When would they diverge badly?


-- 18. Find missing index suggestions using
--     sys.dm_db_missing_index_details after running a few queries.
--     Would you create every suggestion? Why or why not?


-- Challenge

-- 19. Take this slow query, tune it, and document each change with
--     before/after reads:
--       SELECT c.CompanyName,
--              (SELECT COUNT(*) FROM dbo.Orders o
--               WHERE o.CustomerID = c.CustomerID) AS OrderCount,
--              (SELECT MAX(o.OrderDate) FROM dbo.Orders o
--               WHERE o.CustomerID = c.CustomerID) AS LastOrder
--       FROM dbo.Customers c
--       WHERE YEAR((SELECT MAX(o.OrderDate) FROM dbo.Orders o
--                   WHERE o.CustomerID = c.CustomerID)) = 2021;
