{{
  config(
    materialized='table'
  )
}}

with base as (
  select
      session_id
    , user_id 
    , case when event_type = 'page_view' then 1 else 0 end as page_view
    , case when event_type = 'add_to_cart' then 1 else 0 end as add_to_cart
    , case when event_type = 'checkout' then 1 else 0 end as checkout
    , case when event_type = 'package_shipped' then 1 else 0 end as package_shipped
    , order_id
    , min(created_at_utc) as session_start_utc
    , max(created_at_utc) as session_end_utc
  from {{ ref('stg_postgres__events') }}
  group by 1,2,3,4,5,6,7
)

select
    session_id
    , user_id
    , order_id
    , session_start_utc
    , session_end_utc
    , datediff('minute', session_start_utc, session_end_utc) as session_length_min 
    , sum(page_view) as page_views
    , sum(add_to_cart) as add_to_carts
    , sum(checkout) as checkouts
    , sum(package_shipped) as packages_shipped
from base
group by 1,2,3,4,5,6