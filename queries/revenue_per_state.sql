-- TODO: This query will return a table with two columns; customer_state, and
-- Revenue. The first one will have the letters that identify the top 10 states
-- with most revenue and the second one the total revenue of each.
WITH order_customer_pay AS 
(
  SELECT c.customer_state AS 'customer_state', 
  o.order_id AS 'order_id',
  o.order_status AS 'order_status',
  p.payment_value AS 'payment_value'
  FROM olist_customers  c
  JOIN olist_orders  o
  ON o.customer_id = c.customer_id 
  JOIN olist_order_payments p
  ON p.order_id = o.order_id
  WHERE o.order_status <> 'canceled' AND o.order_delivered_customer_date IS NOT NULL 
)

SELECT a.customer_state, 
SUM(a.payment_value) AS 'Revenue'
FROM order_customer_pay a 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;