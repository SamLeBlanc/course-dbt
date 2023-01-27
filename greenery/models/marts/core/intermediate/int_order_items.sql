{{
  config(
    materialized='table'
  )
}}

select 
  int_orders.order_id
  , stg_order_items.product_id
  , int_orders.user_id
  , int_orders.order_created_at_utc
  , int_orders.order_status
  , stg_products.product_name
  , stg_products.product_price 
  , stg_order_items.product_quantity
from {{ ref('int_orders')}} int_orders
left join {{ ref('stg_postgres__order_items') }} stg_order_items using (order_id)
left join {{ ref('stg_postgres__products') }} stg_products using (product_id)