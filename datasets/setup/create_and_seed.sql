/* ============================================================
   SQL Practice — Sample Database Setup
   Run this whole script in SSMS (F5). Safe to re-run: it drops
   and recreates SqlPractice each time so you always start clean.

   Schema: a small "shop" domain — customers, employees (with a
   manager hierarchy for self-joins), categories, products,
   orders, and order line items. ~1,000 orders / ~2,500 line
   items so aggregation, joins, and window functions all have
   enough data to be interesting.
   ============================================================ */

USE master;
GO

IF DB_ID('SqlPractice') IS NOT NULL
BEGIN
    ALTER DATABASE SqlPractice SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SqlPractice;
END
GO

CREATE DATABASE SqlPractice;
GO

USE SqlPractice;
GO

/* ---------------- Tables ---------------- */

CREATE TABLE Categories (
    CategoryID   INT IDENTITY PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    ProductID     INT IDENTITY PRIMARY KEY,
    ProductName   VARCHAR(100) NOT NULL,
    CategoryID    INT NOT NULL REFERENCES Categories(CategoryID),
    UnitPrice     DECIMAL(10,2) NOT NULL,
    Discontinued  BIT NOT NULL DEFAULT 0
);

CREATE TABLE Employees (
    EmployeeID INT IDENTITY PRIMARY KEY,
    FirstName  VARCHAR(50) NOT NULL,
    LastName   VARCHAR(50) NOT NULL,
    Title      VARCHAR(50) NOT NULL,
    HireDate   DATE NOT NULL,
    ManagerID  INT NULL REFERENCES Employees(EmployeeID)
);

CREATE TABLE Customers (
    CustomerID  INT IDENTITY PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100) NOT NULL,
    Country     VARCHAR(50) NOT NULL,
    City        VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    OrderID     INT IDENTITY PRIMARY KEY,
    CustomerID  INT NOT NULL REFERENCES Customers(CustomerID),
    EmployeeID  INT NOT NULL REFERENCES Employees(EmployeeID),
    OrderDate   DATE NOT NULL,
    ShippedDate DATE NULL
);

CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY PRIMARY KEY,
    OrderID       INT NOT NULL REFERENCES Orders(OrderID),
    ProductID     INT NOT NULL REFERENCES Products(ProductID),
    Quantity      INT NOT NULL,
    UnitPrice     DECIMAL(10,2) NOT NULL
);
GO

/* ---------------- Reference data ---------------- */

INSERT INTO Categories (CategoryName) VALUES
('Beverages'), ('Snacks'), ('Electronics'), ('Office Supplies'),
('Home & Kitchen'), ('Toys'), ('Books'), ('Sports');

INSERT INTO Employees (FirstName, LastName, Title, HireDate, ManagerID) VALUES
('Alice', 'Nguyen', 'VP Sales', '2016-01-15', NULL),
('Ben', 'Carter', 'Sales Manager', '2017-03-10', 1),
('Chloe', 'Diaz', 'Sales Manager', '2017-06-22', 1),
('Dan', 'Evans', 'Sales Rep', '2018-02-01', 2),
('Ella', 'Foster', 'Sales Rep', '2018-05-19', 2),
('Frank', 'Grant', 'Sales Rep', '2019-01-11', 3),
('Grace', 'Hughes', 'Sales Rep', '2019-08-30', 3),
('Henry', 'Ito', 'Sales Rep', '2020-04-14', 2),
('Ivy', 'Jones', 'Sales Rep', '2021-02-25', 3),
('Jack', 'Kim', 'Sales Rep', '2022-09-05', 3);

INSERT INTO Customers (CompanyName, ContactName, Country, City) VALUES
('Acme Corp', 'Maria Lopez', 'USA', 'Chicago'),
('Blue Ocean Traders', 'Tom Becker', 'Germany', 'Berlin'),
('Cedar & Co', 'Lin Wei', 'China', 'Shanghai'),
('Delta Retail', 'Sam Okoro', 'Nigeria', 'Lagos'),
('Everest Supplies', 'Priya Rao', 'India', 'Mumbai'),
('Falcon Traders', 'Jean Dupont', 'France', 'Paris'),
('Golden Gate Imports', 'Kevin Wu', 'USA', 'San Francisco'),
('Harbor Point', 'Anna Kowalski', 'Poland', 'Warsaw'),
('Ivory Coast Goods', 'Paul Mensah', 'Ghana', 'Accra'),
('Jasper Retail', 'Olivia Brown', 'UK', 'London'),
('Kite & Wave', 'Marco Rossi', 'Italy', 'Milan'),
('Lotus Group', 'Sakura Ito', 'Japan', 'Tokyo'),
('Maple Traders', 'Emma Wilson', 'Canada', 'Toronto'),
('Nile Commerce', 'Ahmed Hassan', 'Egypt', 'Cairo'),
('Orion Retail', 'Sofia Fernandez', 'Spain', 'Madrid'),
('Pioneer Goods', 'Liam Murphy', 'Ireland', 'Dublin'),
('Quartz Traders', 'Noah Schmidt', 'Germany', 'Munich'),
('Ridge Supplies', 'Ava Johansson', 'Sweden', 'Stockholm'),
('Summit Retail', 'Ethan Clark', 'USA', 'Denver'),
('Terra Nova', 'Isabella Silva', 'Brazil', 'Sao Paulo'),
('Union Traders', 'Mateus Costa', 'Portugal', 'Lisbon'),
('Vantage Point', 'Chen Jing', 'China', 'Beijing'),
('Willow Retail', 'James Taylor', 'USA', 'Austin'),
('Xenon Group', 'Hana Kobayashi', 'Japan', 'Osaka'),
('Yonder Traders', 'Lucas Meyer', 'Germany', 'Hamburg'),
('Zenith Supplies', 'Grace Adeyemi', 'Nigeria', 'Abuja'),
('Apex Commerce', 'Noah Bennett', 'USA', 'Seattle'),
('Beacon Retail', 'Mia Andersen', 'Norway', 'Oslo'),
('Coral Traders', 'Leo Fontaine', 'France', 'Lyon'),
('Driftwood Goods', 'Zoe Campbell', 'USA', 'Portland');

INSERT INTO Products (ProductName, CategoryID, UnitPrice, Discontinued) VALUES
('Espresso Beans 1kg', 1, 14.50, 0),
('Green Tea Box', 1, 6.20, 0),
('Sparkling Water 12pk', 1, 8.99, 0),
('Cold Brew Concentrate', 1, 11.75, 0),
('Orange Juice 1L', 1, 3.49, 0),
('Potato Chips Family Pack', 2, 4.25, 0),
('Trail Mix Bag', 2, 5.10, 0),
('Chocolate Bar Box', 2, 9.60, 0),
('Pretzel Sticks', 2, 3.15, 1),
('Granola Bars 12pk', 2, 7.40, 0),
('Wireless Mouse', 3, 19.99, 0),
('USB-C Hub', 3, 29.50, 0),
('Bluetooth Speaker', 3, 45.00, 0),
('Mechanical Keyboard', 3, 79.99, 0),
('Webcam 1080p', 3, 34.90, 0),
('Noise Cancelling Headphones', 3, 129.00, 0),
('Portable Charger 10000mAh', 3, 24.75, 0),
('Desk Lamp LED', 4, 22.30, 0),
('Sticky Notes Pack', 4, 2.99, 0),
('Ballpoint Pens Box', 4, 4.60, 0),
('Stapler Heavy Duty', 4, 8.75, 0),
('Notebook A5 Ruled', 4, 3.20, 0),
('Whiteboard Markers Set', 4, 6.90, 0),
('File Organizer', 4, 12.40, 1),
('Non-Stick Frying Pan', 5, 27.00, 0),
('Ceramic Mug Set', 5, 15.60, 0),
('Cutting Board Bamboo', 5, 11.20, 0),
('Electric Kettle', 5, 33.50, 0),
('Blender Compact', 5, 41.90, 0),
('Storage Container Set', 5, 18.75, 0),
('Building Blocks Set', 6, 24.99, 0),
('Puzzle 1000pc', 6, 13.50, 0),
('Remote Control Car', 6, 36.20, 0),
('Plush Bear', 6, 9.90, 0),
('Board Game Classic', 6, 28.40, 0),
('Mystery Novel', 7, 10.99, 0),
('Cookbook Modern Kitchen', 7, 18.50, 0),
('Sci-Fi Anthology', 7, 12.75, 0),
('Children Picture Book', 7, 7.99, 0),
('Yoga Mat', 8, 19.20, 0),
('Resistance Bands Set', 8, 14.60, 0),
('Water Bottle Insulated', 8, 9.99, 0),
('Running Shorts', 8, 16.40, 0);
GO

/* ---------------- Orders + line items (generated) ---------------- */

DECLARE @CustomerCount INT = (SELECT COUNT(*) FROM Customers);
DECLARE @EmployeeCount INT = (SELECT COUNT(*) FROM Employees);
DECLARE @ProductCount  INT = (SELECT COUNT(*) FROM Products);

;WITH Tally AS (
    SELECT TOP (1000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShippedDate)
SELECT
    1 + ABS(CHECKSUM(NEWID())) % @CustomerCount,
    1 + ABS(CHECKSUM(NEWID())) % @EmployeeCount,
    od,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 20 = 0 THEN NULL  -- ~5% never shipped
         ELSE DATEADD(DAY, 1 + ABS(CHECKSUM(NEWID())) % 10, od) END
FROM Tally
CROSS APPLY (SELECT DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 730), CAST(GETDATE() AS DATE)) AS od) x;
GO

-- 1 to 5 line items per order
-- Materialize a random line count per order first so NEWID() is evaluated once per order.
SELECT OrderID, 1 + ABS(CHECKSUM(NEWID())) % 5 AS LineCount
INTO #OrderLines
FROM Orders;

-- Materialize random product/quantity per line for the same reason.
SELECT
    ol.OrderID,
    1 + ABS(CHECKSUM(NEWID())) % (SELECT COUNT(*) FROM Products) AS ProductID,
    1 + ABS(CHECKSUM(NEWID())) % 8 AS Quantity
INTO #Lines
FROM #OrderLines ol
JOIN (VALUES (1),(2),(3),(4),(5)) v(n) ON v.n <= ol.LineCount;

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
SELECT l.OrderID, l.ProductID, l.Quantity, p.UnitPrice
FROM #Lines l
JOIN Products p ON p.ProductID = l.ProductID;

DROP TABLE #Lines, #OrderLines;
GO

PRINT 'Done. Row counts:';
SELECT 'Categories' AS TableName, COUNT(*) AS Rows FROM Categories
UNION ALL SELECT 'Products', COUNT(*) FROM Products
UNION ALL SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL SELECT 'OrderDetails', COUNT(*) FROM OrderDetails;
GO
