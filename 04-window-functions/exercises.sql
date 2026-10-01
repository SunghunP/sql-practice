USE SqlPractice;
GO

-- ============================================================
-- 04-window-functions: ROW_NUMBER, RANK, PARTITION BY, running totals
-- ============================================================

-- Ranking functions

-- 1. Number every product from most to least expensive using
--    ROW_NUMBER. Show name, price, and the row number.
SELECT
	p.ProductName,
	p.UnitPrice,
	ROW_NUMBER() OVER (ORDER BY p.UnitPrice DESC)AS RowNumber
FROM dbo.Products p;

-- 2. Rank products by UnitPrice (highest first) using both RANK and
--    DENSE_RANK side by side. Where do they differ, and why?
SELECT 
	p.ProductName,
	p.UnitPrice,
	RANK() OVER (ORDER BY p.UnitPrice DESC) AS [Rank],
	DENSE_RANK() OVER (ORDER BY p.UnitPrice DESC) AS [DenseRank]
FROM dbo.Products p
ORDER BY p.UnitPrice DESC;

-- 3. Rank products within each category by UnitPrice, highest first
--    (category name, product name, price, rank).
SELECT 
  c.CategoryName,
  p.ProductName,
  p.UnitPrice,
  RANK() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS [RANK]
FROM dbo.Products p
INNER JOIN dbo.Categories c 
ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, [RANK], p.ProductName;

-- 4. Return only the single most expensive product per category.
--    (Hint: ranking in a CTE or subquery, then filter.)
WITH Ranked AS (
	SELECT
		c.CategoryName,
		p.ProductName,
		p.UnitPrice,
		ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS rnk
	FROM dbo.Products p
	INNER JOIN dbo.Categories c
	ON p.CategoryID = c.CategoryID
)

SELECT CategoryName, ProductName, UnitPrice
FROM Ranked
WHERE rnk = 1;

-- 5. Return the 3 most recent orders for each customer
--    (CustomerID, OrderID, OrderDate).
WITH ranked AS (
  SELECT 
  CustomerID, 
  Order ID, 
  OrderDate,
  ROW_NUMBER() OVER (
    PARTITION BY CustomerID
    ORDER BY OrderDate DESC, OrderID DESC
  ) AS rn
  FROM Orders
)

SELECT CustomerID, OrderID, OrderDate
FROM ranked
WHERE rn <= 3;

-- 6. Split products into 4 price quartiles using NTILE(4).
--    Show name, price, quartile.


-- Aggregates as window functions

-- 7. For each order line, show OrderID, LineTotal, and the total
--    LineTotal of its entire order on the same row.


-- 8. For each order line, show what percentage of its order's total
--    it represents (rounded to 2 decimals).


-- 9. Show each product's price next to the average price of its
--    category, and the difference between the two.


-- Running totals and frames

-- 10. Show each order's OrderID, OrderDate, and a running count of
--     orders over time (ordered by OrderDate, OrderID).


-- 11. Show daily revenue (per OrderDate) with a running total of
--     revenue across days. (Hint: aggregate first, then window.)


-- 12. Show monthly revenue with a 3-month moving average.
--     (Hint: ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.)


-- LAG / LEAD / FIRST_VALUE

-- 13. For each customer's orders, show OrderDate and the previous
--     order's OrderDate, plus the days between them.


-- 14. Show monthly revenue and the change vs. the previous month
--     (absolute and percent).


-- 15. For each order, show the customer's first-ever OrderDate using
--     FIRST_VALUE.


-- Challenge

-- 16. Find customers whose most recent order is more than 90 days
--     older than the latest OrderDate in the whole table.


-- 17. For each employee, show their best month by revenue
--     (employee full name, month, revenue). Ties: pick the earlier
--     month.


-- 18. Identify "gaps and islands": for each customer, group
--     consecutive-month ordering streaks and return the longest streak
--     length per customer.
