/* 1. How many users do we have? */

select 
    count(distinct user_id) as num_users 
from 
    stg_postgres__users;
    
-- ANSWER: 130 unique users

--------------------------------------------------------------------

/* 2. On average, how many orders do we receive per hour? */

with total_orders_hourly as (
    select 
        trunc(created_at_utc, 'hour') as hour 
        , count(distinct order_id) as num_orders
    from 
        stg_postgres__orders
    group by 1
)

select 
    avg(distinct num_orders) as avg_orders_hourly
from 
    total_orders_hourly;

--ANSWER: 8.666 orders/hr

--------------------------------------------------------------------

/* 3. On average, how long does an order take from being placed to being delivered? */

with order_delivery_times as (
    select 
        order_id
        , datediff('hour',created_at_utc, delivered_at_utc) as hrs_to_deliver
    from 
        stg_postgres__orders
    where 
        delivered_at_utc is not null
    ) 
    
select 
    avg(hrs_to_deliver)
from 
    order_delivery_times;
    
--ANSWER: 93.4 hours

--------------------------------------------------------------------

/* 4. How many users have only made one purchase? Two purchases? Three+ purchases? */

with user_order_count as (
    select 
        user_id
        , count(distinct order_id) as num_orders
    from 
        stg_postgres__orders
    group by 1
)

select 
    case 
        when num_orders >= 3 then '3+' 
        else num_orders::varchar 
        end as num_orders
    , count(distinct user_id) as num_users
from 
    user_order_count
group by 1 
order by 1 asc;

-- ANSWER: 
-- NUM_ORDERS	NUM_USERS
-- 1	        25
-- 2	        28
-- 3+	        71

--------------------------------------------------------------------

/* 5. On average, how many unique sessions do we have per hour? */

with hourly_sessions as (
    select 
        trunc(created_at_utc, 'hour') as hour 
        , count(distinct session_id) as sessions
    from 
        stg_postgres__events
    group by 1
)
    
select 
    avg(sessions)
from 
    hourly_sessions;
    
--ANSWER: 16.3 sessions/hour
