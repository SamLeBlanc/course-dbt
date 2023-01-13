with src as (
    select * from {{source('postgres','promos')}}
)

, renamed_recast as (
    select 
        PROMO_ID
        , DISCOUNT
        , STATUS
    from src
)

select * from renamed_recast