USE SqlPractice;
GO

-- ============================================================
-- 08-interview-prep: hiring-manager style questions (data analyst)
-- ============================================================
-- How to use:
--   The prompts are deliberately vague, like a real interview.
--   For each one:
--     1. Say your clarifying questions out loud (grain? time period?
--        what counts as revenue? NULLs? ties? unshipped orders?).
--     2. Explain your approach BEFORE writing SQL.
--     3. Write the query, then sanity-check the result
--        (row count, totals, edge cases).

-- 1. "What's our total revenue?"

-- 2. "How is revenue trending over time?"

-- 3. "Who are our best customers?"

-- 4. "Which products aren't selling?"

-- 5. "How are our sales reps performing?"

-- 6. "Are customers coming back, or is it all one-time buyers?"

-- 7. "Which categories are growing and which are shrinking?"

-- 8. "How long does it take us to ship orders? Is that a problem?"

-- 9. "Show me each customer's first order and what they bought."

-- 10. "Where is our revenue concentrated? Are we too dependent on a few customers?"

-- ============================================================
-- Part 2: other domains (no tables provided)
-- ============================================================
-- No schema here, like a whiteboard interview. Also ask: what tables
-- and columns exist? What's one row in each table? Are there
-- duplicates, NULLs, test/internal accounts, soft deletes?
-- Sketch the tables you assume, then write the query (practice
-- against the shop schema or your own scratch tables).

-- SaaS
-- 11. "What's our monthly active users?"
-- 12. "What's our churn rate?"
-- 13. "Which signup cohorts retain best?"
-- 14. "How many trial users convert to paid, and how fast?"

-- Healthcare
-- 15. "What's our 30-day readmission rate?"
-- 16. "Which doctors or clinics have the longest patient wait times?"
-- 17. "How many patients missed appointments last quarter, and is it getting worse?"

-- Marketing / e-commerce funnel
-- 18. "Where do users drop off in our checkout funnel?"
-- 19. "Which campaigns are actually worth the money?"

-- Finance / subscriptions
-- 20. "What's our monthly recurring revenue, and how did it change from last month?"
-- 21. "Find customers with overdue invoices."

-- Logistics / operations
-- 22. "Which warehouses are missing their delivery targets?"

-- HR
-- 23. "What's our employee attrition by department?"

-- Education
-- 24. "Which courses have the highest dropout rate?"

-- Data quality (any domain)
-- 25. "Our dashboard shows a different number than finance's report. How do you find out why?"
-- 26. "Find duplicate records in a table and tell me how you'd clean them up."
