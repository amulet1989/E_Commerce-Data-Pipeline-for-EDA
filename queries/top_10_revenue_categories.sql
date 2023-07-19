-- TODO: This query will return a table with the top 10 revenue categories in
-- English, the number of orders and their total revenue. The first column will
-- be Category, that will contain the top 10 revenue categories; the second one
-- will be Num_order, with the total amount of orders of each category; and the
-- last one will be Revenue, with the total revenue of each catgory.
SELECT product_category_name_english AS Category,
COUNT(DISTINCT olist_orders.order_id) AS Num_order,
SUM (olist_order_payments.payment_value) AS Revenue

FROM
    olist_orders
    left JOIN olist_order_payments using(order_id)
    left JOIN olist_order_items using(order_id)
    left JOIN olist_products using(product_id)
    left JOIN product_category_name_translation using(product_category_name)
where
    order_status = 'delivered' and order_delivered_customer_date is not null
group by 1
order by 3 DESC
LIMIT 10;