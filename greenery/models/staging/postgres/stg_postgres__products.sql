with src as (
    select * from {{source('postgres','products')}}
)

, renamed_recast as (
    select 
        PRODUCT_ID
        , NAME as product_name
        , PRICE as product_price
        , INVENTORY as product_inventory
    from src
)

select * from renamed_recast