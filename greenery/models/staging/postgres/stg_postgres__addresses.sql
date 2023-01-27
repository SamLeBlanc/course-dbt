with src as (
    select * from {{source('postgres','addresses')}}
)

, renamed_recast as (
    select 
        ADDRESS_ID
        , ADDRESS as street_address
        , ZIPCODE
        , STATE
        , COUNTRY
        , (ADDRESS||', '||STATE||', '||ZIPCODE) as full_address
    from src
)

select * from renamed_recast