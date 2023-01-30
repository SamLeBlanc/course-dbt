with products as (
    select *
    from {{ ref ('stg_postgres__products') }}
)
, product_sales as (
    select
        product_id,
        sum(product_quantity) as purchased_quantity
    from {{ ref ('stg_postgres__order_items') }}
    group by 1
)

select
    p.product_id
	, p.product_name
	, p.product_price
	, p.product_inventory
    , purchased_quantity
from products p
left join product_sales ps
    on ps.product_id = p.product_id
