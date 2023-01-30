with users as (
    select *
    from {{ ref ('stg_postgres__users') }}
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
    u.user_id
    , o.orders is not null as is_buyer
    , coalesce(o.orders, 0) >= 2 as is_frequent_buyer
    , o.first_order_utc
    , o.last_order_utc
    , o.orders
    , coalesce(o.spend_usd, 0) as spend_usd
    , coalesce(p.distinct_products_purchased, 0) as distinct_products_purchased
    , coalesce(p.items_purchased, 0) as items_purchased
from users u
left join user_orders o
    on o.user_id = u.user_id
left join products_purchased p
    on p.user_id = u.user_id