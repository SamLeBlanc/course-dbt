{{
  config(
    materialized='table'
  )
}}

select 
  stg_orders.order_id
  , stg_orders.user_id
  , stg_orders.address_id
  , stg_orders.promo_desc
  , stg_orders.order_created_at_utc
  , stg_orders.order_cost
  , stg_orders.shipping_cost
  , stg_promos.discount
  , stg_orders.order_total
  , stg_orders.tracking_id
  , stg_orders.order_status 
from {{ ref('stg_postgres__orders') }} stg_orders
left join {{ref('stg_postgres__promos')}} stg_promos USING (promo_desc)