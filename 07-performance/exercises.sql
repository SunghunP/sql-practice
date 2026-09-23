USE SqlPractice;
GO

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
