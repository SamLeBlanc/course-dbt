with src as (
    select * from {{source('postgres','orders')}}
)

, renamed_recast as (
    select 
        ORDER_ID
        , USER_ID 
        , PROMO_ID as promo_desc
        , ADDRESS_ID
        , CREATED_AT::timestampntz as order_created_at_utc
        , ORDER_COST
        , SHIPPING_COST
        , ORDER_TOTAL
        , TRACKING_ID
        , SHIPPING_SERVICE
        , ESTIMATED_DELIVERY_AT::timestampntz as order_estimated_delivery_at_utc
        , DELIVERED_AT::timestampntz as order_delivered_utc
        , STATUS as order_status
    from src
)

select * from renamed_recast