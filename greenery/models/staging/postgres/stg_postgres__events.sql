with src as (
    select * from {{source('postgres','events')}}
)

, renamed_recast as (
    select 
        EVENT_ID
        , SESSION_ID
        , USER_ID
        , PAGE_URL
        , CREATED_AT::timestampntz as created_at_utc
        , EVENT_TYPE
        , ORDER_ID
        , PRODUCT_ID
    from src
)

select * from renamed_recast