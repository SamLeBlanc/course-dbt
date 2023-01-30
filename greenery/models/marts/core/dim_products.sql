with products as (
    select * from {{ ref ('stg_postgres__products') }}
)
, product_sales as (
    select
        product_id,
        sum(product_quantity) as purchased_quantity
    from {{ ref ('stg_postgres__order_items') }}
    group by 1
)

select
    products.product_id
	, products.product_name
	, products.product_price
	, products.product_inventory
    , purchased_quantity
from products
left join product_sales
    on product_sales.product_id = products.product_id
