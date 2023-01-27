{{
  config(
    materialized='table'
  )
}}

with sessions_summary_by_day as (
  select 
  product_id
  , trunc(session_start_utc, 'day') as session_start_date 
  , sum(page_views) as page_views
  , count(distinct case when checkout > 0 then order_id end) as orders
  from {{ ref('int_user_product_sessions')}}
  group by 1,2 
)

select 
stg_products.product_id
, stg_products.product_name
, avg(page_views) as avg_page_views
, avg(orders) as avg_orders
, min(session_start_date) as first_session
, max(session_start_date) as last_session
from {{ ref('stg_postgres__products') }} stg_products
left join sessions_summary_by_day using (product_id)
group by 1,2