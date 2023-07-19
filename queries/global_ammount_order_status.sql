-- TODO: This query will return a table with two columns; order_status, and
-- Ammount. The first one will have the different order status classes and the
-- second one the total ammount of each.
SELECT o.order_status, 
COUNT(*) AS 'Ammount'
FROM olist_orders AS o
GROUP BY o.order_status; 