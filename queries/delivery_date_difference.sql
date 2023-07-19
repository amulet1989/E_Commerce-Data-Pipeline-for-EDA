-- TODO: This query will return a table with two columns; State, and
-- Delivery_Difference. The first one will have the letters that identify the
-- states, and the second one the average difference between the estimate
-- delivery date and the date when the items were actually delivered to the
-- customer.
with dates AS 
  (
    SELECT date(o.order_delivered_customer_date) as customer_date,
    date(o.order_estimated_delivery_date) as estimated_date,
    o.customer_id AS customer_id,
    o.order_status AS order_status
    FROM olist_orders o
  )
select c.customer_state AS State,
CAST((AVG(julianday(d.estimated_date)  - julianday(d.customer_date))) AS INTEGER)
AS Delivery_Difference
from dates d
JOIN olist_customers c using(customer_id)
WHERE d.order_status = 'delivered' 
GROUP BY 1
ORDER BY 2;