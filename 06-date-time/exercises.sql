USE SqlPractice;
GO

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
