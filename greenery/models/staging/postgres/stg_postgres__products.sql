with src as (
    select * from {{source('postgres','products')}}
)

, renamed_recast as (
    select 
        PRODUCT_ID
        , NAME
        , PRICE
        , INVENTORY
    from src
)

select * from renamed_recast