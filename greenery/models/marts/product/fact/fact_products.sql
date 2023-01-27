{{
  config(
    materialized='table'
  )
}}

with order_items_summary as (
  select 
  product_id
  , sum(product_quantity) as num_purchases
  , count(distinct order_id) as num_orders
  , min(order_created_at_utc) as first_order_date
  , max(order_created_at_utc) as last_order_date
  from {{ ref('int_order_items')}}
  group by 1
)

select *
from {{ ref('stg_postgres__products') }}
left join order_items_summary using (product_id)