-- 1. List the 3 most expensive products whose name contains 'Set' or 'Kit', with a price of at least 10. Show the name, the price, and the price rounded to a whole-dollar INT as RoundedPrice. Break ties by name A-Z.
SELECT TOP 3
	p.ProductName,
	p.UnitPrice,
	CAST(ROUND(p.UnitPrice, 0) AS INT) AS RoundedPrice
FROM dbo.Products p
WHERE
	(p.ProductName LIKE '%Set%' OR p.ProductName LIKE '%Kit%') AND
	p.UnitPrice >= 10
ORDER BY p.UnitPrice DESC, p.ProductName;

-- 2. Using a FULL JOIN between Customers and Orders, list customers with no orders and orders with no matching customer.
SELECT
	c.CompanyName,
	o.OrderID
FROM dbo.Customers c
FULL JOIN dbo.Orders o
	ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL OR c.CustomerID IS NULL;

-- 3. List employees who were hired before their own manager.
SELECT
	e.FirstName + ' ' + e.LastName AS Employee
FROM dbo.Employees e
INNER JOIN dbo.Employees me
	ON e.ManagerID = me.EmployeeID
WHERE e.HireDate < me.HireDate;

-- 4. Show revenue per customer (company name) counting only orders placed in 2021, and only customers whose 2021 revenue exceeds 5000. Highest first.
SELECT
	c.CustomerID,
	c.CompanyName,
	SUM(od.UnitPrice * od.Quantity) AS TotalRevenue
FROM dbo.Customers c
INNER JOIN dbo.Orders o
	ON c.CustomerID = o.CustomerID
INNER JOIN dbo.OrderDetails od
	ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '2021-01-01' AND o.OrderDate < '2022-01-01'
GROUP BY c.CustomerID, c.CompanyName
HAVING SUM(od.UnitPrice * od.Quantity) > 5000
ORDER BY TotalRevenue DESC, c.CustomerID;

-- 5. Show the number of orders handled per employee (full name + count), including employees with zero orders.
SELECT
	e.EmployeeID,
	e.FirstName + ' ' + e.LastName AS FullName,
	COUNT(o.OrderID) AS HandledOrders
FROM dbo.Employees e
LEFT JOIN dbo.Orders o
	ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

-- 6. Show monthly revenue and the change vs. the previous month (absolute and percent).
WITH Monthly AS (
	SELECT
		YEAR(o.OrderDate)  AS OrderYear,
		MONTH(o.OrderDate) AS OrderMonth,
		SUM(od.Quantity * od.UnitPrice) AS Revenue
	FROM dbo.Orders o
	INNER JOIN dbo.OrderDetails od
		ON o.OrderID = od.OrderID
	GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
),
WithPrev AS (
	SELECT
		OrderYear,
		OrderMonth,
		Revenue,
		LAG(Revenue) OVER (ORDER BY OrderYear, OrderMonth) AS PrevRevenue
	FROM Monthly
)
SELECT
	OrderYear,
	OrderMonth,
	Revenue,
	PrevRevenue,
	Revenue - PrevRevenue AS AbsChange,
	ROUND((Revenue - PrevRevenue) / NULLIF(PrevRevenue, 0) * 100, 2) AS PctChange
FROM WithPrev
ORDER BY OrderYear, OrderMonth;

-- 7. Return only the single most expensive product per category.
WITH Ranked AS (
	SELECT
		c.CategoryName,
		p.ProductName,
		p.UnitPrice,
		ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS rn
	FROM dbo.Products p
	INNER JOIN dbo.Categories c
		ON p.CategoryID = c.CategoryID
)
SELECT
	CategoryName,
	ProductName,
	UnitPrice
FROM Ranked
WHERE rn = 1;

-- 8. List customers who have never placed an order, using NOT EXISTS. Why is NOT IN risky here?
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

-- 9. List orders whose total value is higher than the average total value of all orders placed by the same customer.
WITH OrderTotals AS (  -- total value of each order, tagged with its customer
	SELECT
		o.CustomerID,
		od.OrderID,
		SUM(od.Quantity * od.UnitPrice) AS OrderTotal
	FROM dbo.OrderDetails od
	INNER JOIN dbo.Orders o
		ON od.OrderID = o.OrderID
	GROUP BY o.CustomerID, od.OrderID
), CustomerAvg AS (  -- average order total per customer
	SELECT
		CustomerID,
		AVG(OrderTotal) AS AverageOrderTotal
	FROM OrderTotals
	GROUP BY CustomerID
), OrdersVsAvg AS (  -- each order alongside its customer's average
	SELECT
		ot.CustomerID,
		ot.OrderID,
		ot.OrderTotal,
		cv.AverageOrderTotal
	FROM OrderTotals ot
	INNER JOIN CustomerAvg cv
		ON ot.CustomerID = cv.CustomerID
)
SELECT
	CustomerID,
	OrderID,
	OrderTotal,
	AverageOrderTotal
FROM OrdersVsAvg
WHERE OrderTotal > AverageOrderTotal
ORDER BY CustomerID, OrderTotal, OrderID;

-- 10. Show each employee's full name and tenure in whole years as of today. DATEDIFF(YEAR, ...) counts calendar boundaries, so it can be off by one. Write an accurate version.
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

-- 11. For each category, show the number of products, the number of discontinued products, and the average unit price (2 decimals). Include categories with zero products.
WITH ProductCounts AS (
-- get Count of products per category
  SELECT
    CategoryID,
    COUNT(ProductID) AS ProductCount
  FROM dbo.products 
  GROUP BY CategoryID
), DiscontinuedCounts AS (
-- get Count of discontinued products per category
  SELECT
    CategoryID,
    COUNT(ProductID) AS DiscontinuedCount
  FROM dbo.products
  WHERE Discontinued = 1
  GROUP BY CategoryID
), AvgUnitPrices AS (
-- get Average Unit Price per category
  SELECT
    CategoryID,
    AVG(UnitPrice) AS AvgUnitPrice
  FROM dbo.products
  GROUP BY CategoryID
), final AS (
-- combine product counts, discontinued counts, and average unit prices per category
  SELECT
    pc.CategoryID,
    pc.ProductCount,
    dc.DiscontinuedCount,
    aup.AvgUnitPrice
  FROM ProductCounts pc
  LEFT JOIN DiscontinuedCounts dc
    ON pc.CategoryID = dc.CategoryID
  LEFT JOIN AvgUnitPrices aup
    ON pc.CategoryID = aup.CategoryID
)

SELECT
  CategoryID,
  ProductCount,
  COALESCE(DiscontinuedCount, 0) AS DiscontinuedCount,
  ROUND(AvgUnitPrice, 2) AS AvgUnitPrice
FROM final

-- alternative approach without CTEs
SELECT
  CategoryID,
  COUNT(ProductID) AS ProductCount,
  SUM(CASE WHEN Discontinued = 1 THEN 1 ELSE 0 END) AS DiscontinuedCount,
  ROUND(AVG(UnitPrice), 2) AS AvgUnitPrice
FROM dbo.products
GROUP BY CategoryID

-- ============================================================
-- StrataScratch challenges (different schema, won't run against SqlPractice)
-- ============================================================

-- 11. Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.
SELECT DISTINCT p.*
FROM facebook_reactions r
INNER JOIN facebook_posts p
	ON r.post_id = p.post_id
	AND r.reaction = 'heart';

-- 12. Calculate the number of shipments per month. The unique key for one shipment is a combination of shipment_id and sub_id. Output the year_month in format YYYY-MM and the number of shipments in that month.
WITH shipments AS (
	SELECT
		CAST(shipment_ID AS VARCHAR(50)) + CAST(sub_id AS VARCHAR(50)) AS ship_id,
		FORMAT(shipment_date, 'yyyy-MM') AS year_month
	FROM amazon_shipment
)
SELECT
	COUNT(ship_id) AS number_shipped,
	year_month
FROM shipments
GROUP BY year_month;

-- 13. Return the number of unique users per client for each month. Assume all events occur within the same year, so only month needs to be in the output as a number from 1 to 12.
WITH client_counts AS (
	SELECT
		client_id,
		user_id,
		MONTH(time_id) AS month_num
	FROM fact_events
)
SELECT
	client_id,
	COUNT(DISTINCT user_id) AS user_count,
	month_num
FROM client_counts
GROUP BY client_id, month_num;

