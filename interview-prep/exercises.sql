USE SqlPractice;
GO

-- ============================================================
-- 06-date-time: date math, DATEDIFF/DATEADD, formatting
-- ============================================================

-- Extracting parts

-- 1. Show each order's OrderID, year, month, and day of week name
--    (use YEAR, MONTH, DATENAME).
SELECT
  OrderID,
  DATEPART(YEAR, o.OrderDate) AS [Year],
  DATEPART(MONTH, o.OrderDate) AS [Month],
  DATENAME(WEEKDAY, o.OrderDate) AS [Weekday]
FROM dbo.Orders o;

-- 2. List orders placed on a weekend. (Careful: DATEPART(WEEKDAY, ...)
--    depends on DATEFIRST. Use DATENAME or check @@DATEFIRST.)
SELECT
  OrderID,
  DATENAME(WEEKDAY, o.OrderDate) AS [Weekday]
FROM dbo.Orders o
WHERE DATENAME(WEEKDAY, o.OrderDate) IN ('Saturday', 'Sunday');

-- 3. Show the quarter each order was placed in and the number of
--    orders per quarter.
SELECT
  YEAR(o.OrderDate) AS OrderYear,
  DATEPART(QUARTER, o.OrderDate) AS OrderQuarter,
  COUNT(*) AS OrderCount
FROM dbo.Orders o
GROUP BY YEAR(o.OrderDate), DATEPART(QUARTER, o.OrderDate)
ORDER BY OrderYear, OrderQuarter;

-- DATEDIFF / DATEADD

-- 4. For shipped orders, show OrderID and the number of days between
--    OrderDate and ShippedDate.
SELECT
  o.OrderID,
  DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS DaysToShip
FROM dbo.Orders o
WHERE o.ShippedDate IS NOT NULL;

-- 5. List orders that took more than 7 days to ship.
WITH OrderDaysToShip AS (
  SELECT
    o.OrderID,
    DATEDIFF(DAY, o.OrderDate, o.ShippedDate) AS DaysToShip
  FROM dbo.Orders o
)
SELECT 
  OrderID,
  DaysToShip
FROM OrderDaysToShip
WHERE DaysToShip > 7;


-- 6. Show each employee's full name and tenure in whole years as of
--    today. Note: DATEDIFF(YEAR, ...) counts calendar boundaries, so
--    it can be off by one. Write an accurate version.
SELECT
  e.EmployeeID,
  e.FirstName + ' ' + e.LastName AS FullName,
  DATEDIFF(YEAR, e.HireDate, GETDATE())
    - CASE
        WHEN DATEADD(YEAR, DATEDIFF(YEAR, e.HireDate, GETDATE()), e.HireDate) > GETDATE()
        THEN 1
        ELSE 0
      END AS Tenure
FROM dbo.Employees e;

-- 7. For each order, show a "due date" 14 days after OrderDate.
SELECT
  o.OrderID,
  o.OrderDate,
  DATEADD(DAY, 14, o.OrderDate) AS DueDate
FROM dbo.Orders o;

-- 8. List orders that are unshipped and were placed more than 30 days
--    before the latest OrderDate in the table.
SELECT
  o.OrderID,
  o.OrderDate
FROM dbo.Orders o
WHERE o.ShippedDate IS NULL
  AND o.OrderDate < DATEADD(DAY, -30, (SELECT MAX(OrderDate) FROM dbo.Orders));

-- Truncating and boundaries
-- 9. Show the first day of the month for each OrderDate, and the number
--    of orders per month. (Hint: DATEFROMPARTS or EOMONTH tricks.)
SELECT
  o.OrderID,
  DATEFROMPARTS(YEAR(o.OrderDate), MONTH(o.OrderDate), 1) AS FirstDayOfMonth,
  COUNT(*) AS OrdersPerMonth
FROM dbo.Orders o
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate);

-- 10. List orders placed in the last full calendar month of the data
--     (relative to MAX(OrderDate)), without hard-coding dates.
WITH bounds AS (
  SELECT
    DATEADD(DAY, 1, EOMONTH(MAX(OrderDate), -2)) AS StartDate,  -- 1st of previous month
    DATEADD(DAY, 1, EOMONTH(MAX(OrderDate), -1)) AS EndDate     -- 1st of max's month (exclusive)
  FROM dbo.Orders
)
SELECT o.*
FROM dbo.Orders o
CROSS JOIN bounds b
WHERE o.OrderDate >= b.StartDate
  AND o.OrderDate <  b.EndDate
ORDER BY o.OrderDate;

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


-- ============================================================
-- Challenge (saved for later)
-- ============================================================

-- 04-window-functions

-- 16. Find customers whose most recent order is more than 90 days
--     older than the latest OrderDate in the whole table.


-- 17. For each employee, show their best month by revenue
--     (employee full name, month, revenue). Ties: pick the earlier
--     month.


-- 18. Identify "gaps and islands": for each customer, group
--     consecutive-month ordering streaks and return the longest streak
--     length per customer.


-- 05-cte-subqueries

-- 21. Find the product pairs most often bought together in the same
--     order (product A name, product B name, times together).
--     Avoid duplicates like (A,B) and (B,A).


-- 22. For each category, find the product with the highest total
--     revenue. Do it two ways: with a correlated subquery and with a
--     CTE. Compare the results.
