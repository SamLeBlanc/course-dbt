with order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
)
, orders as (
    select * from {{ ref('stg_postgres__orders') }}
)

select
    orders.user_id
    , orders.order_id
    , orders.order_created_at_utc
    , order_items.product_id
    , order_items.product_quantity
from order_items
left join orders
    on orders.order_id = order_items.order_id