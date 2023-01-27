{{
  config(
    materialized='table'
  )
}}

with views_cart as (
select
    session_id
  , user_id 
  , product_id 
  , case when event_type = 'page_view' then 1 else 0 end as page_view
  , case when event_type = 'add_to_cart' then 1 else 0 end as add_to_cart
  , min(created_at_utc) as session_start_utc
  , max(created_at_utc) as session_end_utc
from {{ ref('stg_postgres__events') }}
where event_type in ('page_view','add_to_cart')
group by 1,2,3,4,5
)

, checkout_shipped as (
  select
  session_id
  , user_id
  , case when event_type = 'checkout' then 1 else 0 end as checkout
  , case when event_type = 'package_shipped' then 1 else 0 end as package_shipped
  , order_id
  , min(created_at_utc) as session_start_utc
  , max(created_at_utc) as session_end_utc
  from {{ ref('stg_postgres__events') }}
  where event_type in ('checkout','package_shipped')
  group by 1,2,3,4,5
)

, views_cart_pivot as (
    select 
    session_id
    , user_id
    , product_id
    , min(session_start_utc) as session_start_utc
    , max(session_end_utc) as session_end_utc
    , sum(page_view) as page_views
    , sum(add_to_cart) as add_to_cart
    from views_cart
    group by 1,2,3
)

, checkout_shipped_pivot as (
    select 
    session_id
    , user_id
    , order_id
    , min(session_start_utc) as session_start_utc
    , max(session_end_utc) as session_end_utc
    , case when sum(checkout) > 0 then 1 else 0 end as checkout
    , case when sum(package_shipped) > 0 then 1 else 0 end as package_shipped
    from checkout_shipped
    group by 1,2,3
)

select
    views_cart_pivot.session_id
    , views_cart_pivot.user_id
    , views_cart_pivot.product_id
    , checkout_shipped_pivot.order_id
    , case when views_cart_pivot.session_start_utc < checkout_shipped_pivot.session_start_utc then views_cart_pivot.session_start_utc else checkout_shipped_pivot.session_start_utc end as session_start_utc
    , case when views_cart_pivot.session_end_utc < checkout_shipped_pivot.session_end_utc then views_cart_pivot.session_end_utc else checkout_shipped_pivot.session_end_utc end as session_end_utc
    , datediff('minute', session_start_utc, session_end_utc) as session_length_min 
    , views_cart_pivot.page_views
    , views_cart_pivot.add_to_cart
    , checkout_shipped_pivot.checkout
    , checkout_shipped_pivot.package_shipped
from views_cart_pivot
left join checkout_shipped_pivot using (session_id, user_id)