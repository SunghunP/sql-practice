USE SqlPractice;
GO

-- ============================================================
-- 05-cte-subqueries: CTEs, correlated subqueries, recursive CTEs
-- ============================================================

-- Scalar and IN subqueries

-- 1. List products priced above the average UnitPrice of all products.


-- 2. List customers who have placed at least one order
--    (use IN with a subquery, then rewrite with EXISTS).


-- 3. List customers who have never placed an order, using NOT EXISTS.
--    Why is NOT IN risky here if the subquery can return NULLs?


-- 4. List products that appear in at least one order placed in 2021.


-- Subqueries in FROM / SELECT

-- 5. Show each product's name, price, and the average price of its
--    category via a scalar subquery in the SELECT list.


-- 6. Using a subquery in FROM, show the average number of order lines
--    per order.


-- Correlated subqueries

-- 7. For each customer, show the date of their most recent order
--    using a correlated subquery.


-- 8. List products that cost more than the average price of their
--    own category.


-- 9. List orders whose total value is higher than the average total
--    value of all orders placed by the same customer.


-- CTEs

-- 10. Rewrite #6 with a CTE.


-- 11. Using a CTE, list the top 5 customers by total revenue
--     (company name + revenue).


-- 12. Using two chained CTEs: first compute revenue per order, then
--     per customer average order revenue. Show customers whose average
--     is above the overall average.


-- 13. Using a CTE, find employees who handled more orders than the
--     average employee.


-- Recursive CTEs

-- 14. Generate the numbers 1 through 20 with a recursive CTE.


-- 15. Show the full employee hierarchy: each employee with their
--     level (top manager = 0) and the chain of manager names as a
--     string (e.g. 'Smith > Jones > Lee').


-- 16. For a given manager (pick one), list every direct and indirect
--     report.


-- 17. Generate every date in 2021 with a recursive CTE, then LEFT JOIN
--     to Orders to show the number of orders per day, including days
--     with zero orders.


-- Challenge

-- 18. Find the product pairs most often bought together in the same
--     order (product A name, product B name, times together).
--     Avoid duplicates like (A,B) and (B,A).


-- 19. For each category, find the product with the highest total
--     revenue. Do it two ways: with a correlated subquery and with a
--     CTE. Compare the results.
