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


-- 4. List customers who have placed at least one order
--    (use IN with a subquery, then rewrite with EXISTS).


-- 5. List customers who have never placed an order, using NOT EXISTS.
--    Why is NOT IN risky here if the subquery can return NULLs?


-- 6. List products that appear in at least one order placed in 2021.


-- Subqueries in FROM / SELECT

-- 7. Show each product's name, price, and the average price of its
--    category via a scalar subquery in the SELECT list.


-- 8. Using a subquery in FROM, show the average number of order lines
--    per order.


-- Correlated subqueries

-- 9. For each customer, show the date of their most recent order
--    using a correlated subquery.


-- 10. List products that cost more than the average price of their
--    own category.


-- 11. List orders whose total value is higher than the average total
--    value of all orders placed by the same customer.


-- CTEs

-- 12. Rewrite #8 with a CTE.


-- 13. Using a CTE, list the top 5 customers by total revenue
--     (company name + revenue).


-- 14. Using two chained CTEs: first compute revenue per order, then
--     per customer average order revenue. Show customers whose average
--     is above the overall average.


-- 15. Using a CTE, find employees who handled more orders than the
--     average employee.


-- Recursive CTEs

-- 16. Generate the numbers 1 through 20 with a recursive CTE.


-- 17. Show the full employee hierarchy: each employee with their
--     level (top manager = 0) and the chain of manager names as a
--     string (e.g. 'Smith > Jones > Lee').


-- 18. For a given manager (pick one), list every direct and indirect
--     report.


-- 19. Generate every date in 2021 with a recursive CTE, then LEFT JOIN
--     to Orders to show the number of orders per day, including days
--     with zero orders.


-- Challenge

-- 20. Find the product pairs most often bought together in the same
--     order (product A name, product B name, times together).
--     Avoid duplicates like (A,B) and (B,A).


-- 21. For each category, find the product with the highest total
--     revenue. Do it two ways: with a correlated subquery and with a
--     CTE. Compare the results.
