{{
  config(
    materialized='table'
  )
}}

with order_items_summary as (
  select 
  order_id
  , sum(product_quantity) as num_products
  , count(distinct product_id) as num_unique_products
  , sum(product_quantity * product_price) as total_product_price
  , sum(product_quantity * product_price) * 1.0 / sum(product_quantity) as avg_product_price
  from {{ ref('int_order_items') }}
  group by order_id
)

select *
from {{ ref('int_orders') }} int_orders
left join order_items_summary using (order_id)