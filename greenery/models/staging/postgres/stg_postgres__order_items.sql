with src as (
    select * from {{source('postgres','order_items')}}
)

, renamed_recast as (
    select 
        ORDER_ID
        , PRODUCT_ID
        , QUANTITY::int as product_quantity
    from src
)

select * from renamed_recast