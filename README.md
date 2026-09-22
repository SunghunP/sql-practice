# SQL Practice

A self-paced SQL practice repo using SQL Server (T-SQL) in SSMS.

## Setup

1. Open [datasets/setup/create_and_seed.sql](datasets/setup/create_and_seed.sql) in SSMS.
2. Hit Execute (F5). It creates a `SqlPractice` database with a small shop
   schema (customers, employees, categories, products, orders, order
   details) and seeds it with randomized data (~1,000 orders, ~2,500 line
   items). Safe to re-run any time — it drops and recreates the database.

Schema summary:

- `Categories` → `Products`
- `Employees` (self-referencing `ManagerID`, for hierarchy practice)
- `Customers`
- `Orders` (→ `Customers`, `Employees`)
- `OrderDetails` (→ `Orders`, `Products`)

## How this repo is organized

Each numbered folder is a topic. Inside, exercises are in `exercises.sql`
(just the prompts) and answers are in `solutions.sql` (try the exercise
first before peeking).

- `01-fundamentals` — SELECT, WHERE, ORDER BY, DISTINCT, TOP, basic functions
- `02-joins` — INNER/LEFT/RIGHT/FULL, self-joins, multi-table joins
- `03-aggregation-grouping` — GROUP BY, HAVING, aggregate functions
- `04-window-functions` — ROW_NUMBER, RANK, PARTITION BY, running totals
- `05-cte-subqueries` — CTEs, correlated subqueries, recursive CTEs
- `06-date-time` — date math, DATEDIFF/DATEADD, formatting
- `07-performance` — execution plans, indexing, query tuning
- `challenges` — mixed, harder problems that pull from multiple topics
