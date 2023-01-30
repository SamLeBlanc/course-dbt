with users as (
    select * from {{ ref ('stg_postgres__users') }}
)
, user_orders as (
    select 
        user_id
        , min(order_created_at_utc) as first_order_utc
        , max(order_created_at_utc) as last_order_utc
        , sum(order_cost) as spend_usd
        , count(order_id) as orders
    from {{ ref ('stg_postgres__orders') }}
    group by 1
)
, products_purchased as (
    select
        user_id
        , count(distinct product_id) as distinct_products_purchased
        , sum(product_quantity) as items_purchased
    from {{ ref('int_user_order_product') }}
    group by 1
)

select
    users.user_id
    , user_orders.orders is not null as is_buyer
    , coalesce(user_orders.orders, 0) >= 3 as is_frequent_buyer
    , user_orders.first_order_utc
    , user_orders.last_order_utc
    , user_orders.orders
    , coalesce(user_orders.spend_usd, 0) as spend_usd
    , coalesce(products_purchased.distinct_products_purchased, 0) as distinct_products_purchased
    , coalesce(products_purchased.items_purchased, 0) as items_purchased
from users
left join user_orders
    on user_orders.user_id = users.user_id
left join products_purchased
    on products_purchased.user_id = users.user_id