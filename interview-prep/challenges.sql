Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.

SELECT DISTINCT p.*
FROM facebook_reactions r
INNER JOIN facebook_posts p
ON 
  r.post_id = p.post_id AND
  r.reaction = 'heart';

WITH shipments AS (
    SELECT
        CAST(shipment_ID AS VARCHAR(50)) + CAST(sub_id AS VARCHAR(50)) AS ship_id,
        FORMAT(shipment_date, 'yyyy-MM') AS year_month 
    FROM amazon_shipment
)

Write a query that will calculate the number of shipments per month. The unique key for one shipment is a combination of shipment_id and sub_id. Output the year_month in format YYYY-MM and the number of shipments in that month.
SELECT 
    COUNT(ship_id) AS number_shipped,
    year_month 
FROM shipments
GROUP BY year_month;

Write a query that returns the number of unique users per client for each month. Assume all events occur within the same year, so only month needs to be be in the output as a number from 1 to 12.
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