{{
  config(
    materialized='table'
  )
}}

with orders_summary as (
    select
    user_id
    , count(distinct order_id) as num_orders
    , sum(order_cost) as total_orders_cost
    , sum(shipping_cost) as total_shipping_cost
    , sum(order_total) as num_orders_total
    , sum(discount) as total_discount
    , min(order_created_at_utc) as first_order_date
    , max(order_created_at_utc) as last_order_date
    from {{ ref('int_orders') }}
    group by user_id
)

, order_items_summary as (
    select 
    user_id
    , sum(product_quantity) as total_num_items
    , count(distinct product_id) as unique_items
    , sum(product_quantity*product_price)*1.0/sum(product_quantity) as avg_item_price
    , sum(product_quantity*product_price) as total_item_price
    from {{ ref('int_order_items') }}
    group by user_id
)

select *
from {{ ref('dim_users') }}
left join orders_summary using (user_id)
left join order_items_summary using (user_id)