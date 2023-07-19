-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
with con_null AS (
select month as month_no,
                case
                    when a.month='01' then 'Jan'
                    when a.month='02' then 'Feb'
                    when a.month='03' then 'Mar'
                    when a.month='04' then 'Apr'
                    when a.month='05' then 'May'
                    when a.month='06' then 'Jun'
                    when a.month='07' then 'Jul'
                    when a.month='08' then 'Aug'
                    when a.month='09' then 'Sep'
                    when a.month='10' then 'Oct'
                    when a.month='11' then 'Nov'
                    when a.month='12' then 'Dec'
                    else 0
                end as month,
                sum(case
                        when a.year= '2016' then payment_value
                    end) as Year2016,
                sum(case
                        when a.year= '2017' then payment_value
                    end) as Year2017,
                sum(case
                        when a.year= '2018' then payment_value
                    end) as Year2018
from
    (select customer_id,
            order_id,
            order_delivered_customer_date,
            order_status,
            strftime('%Y',order_delivered_customer_date) as Year,
            strftime('%m',order_delivered_customer_date) as Month,
            payment_value
     from olist_orders
     inner join olist_order_payments using (order_id)
     where order_status = 'delivered'
         and order_delivered_customer_date is not null
     group by 2 -- to get distinct orders_id
     order by order_delivered_customer_date asc) a
     
group by month
order by month_no asc
)

SELECT month_no, month, 
COALESCE (Year2016,0.00) Year2016, 
COALESCE (Year2017,0.00) Year2017,
COALESCE (Year2018,0.00) Year2018
from con_null; 