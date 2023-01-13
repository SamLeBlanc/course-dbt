with src as (
    select * from {{source('postgres','addresses')}}
)

, renamed_recast as (
    select 
        ADDRESS_ID
        , ADDRESS
        , ZIPCODE
        , STATE
        , COUNTRY
    from src
)

select * from renamed_recast