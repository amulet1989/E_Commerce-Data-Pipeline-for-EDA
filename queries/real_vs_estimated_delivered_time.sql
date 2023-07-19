-- TODO: This query will return a table with the differences between the real
-- and estimated delivery times by month and year. It will have different
-- columns: month_no, with the month numbers going from 01 to 12; month, with
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with
-- the average delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if
-- it doesn't exist); Year2018_real_time, with the average delivery time per
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_estimated_time, with the average estimated delivery time per month
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
select month_no,
                case
                    when a.month_no ='01' then 'Jan'
                    when a.month_no ='02' then 'Feb'
                    when a.month_no ='03' then 'Mar'
                    when a.month_no ='04' then 'Apr'
                    when a.month_no ='05' then 'May'
                    when a.month_no ='06' then 'Jun'
                    when a.month_no ='07' then 'Jul'
                    when a.month_no ='08' then 'Aug'
                    when a.month_no ='09' then 'Sep'
                    when a.month_no ='10' then 'Oct'
                    when a.month_no ='11' then 'Nov'
                    when a.month_no ='12' then 'Dec'
                end as month,
                -- real time
                avg(case when a.Year = '2016' then a.customer_date end) as Year2016_real_time,
                avg(case when a.Year = '2017' then a.customer_date end) as Year2017_real_time,
                avg(case when a.Year = '2018' then a.customer_date end) as Year2018_real_time,
                    
                -- estimated time
                avg(case when a.Year = '2016' then a.estimated_day end) as Year2016_estimated_time,
                avg(case when a.Year = '2017' then a.estimated_day end) as Year2017_estimated_time,
                avg(case when a.Year = '2018' then a.estimated_day end) as Year2018_estimated_time
from
    (select order_id,
            customer_id,
            julianday(order_delivered_customer_date)- julianday(order_purchase_timestamp)
            AS customer_date,
            julianday(order_estimated_delivery_date)- julianday(order_purchase_timestamp)
            AS estimated_day,
            -- order_status,
            strftime('%Y',order_purchase_timestamp) as Year,
            strftime('%m',order_purchase_timestamp) as month_no
                   
     from olist_orders
     where order_status = 'delivered' 
     AND order_delivered_customer_date is not null
     group by 1,2
     order by order_purchase_timestamp asc) a
     
group by month
order by month_no asc;