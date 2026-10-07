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
