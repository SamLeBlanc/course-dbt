with src as (
    select * from {{source('postgres','users')}}
)

, renamed_recast as (
    select 
        USER_ID
        , FIRST_NAME
        , LAST_NAME
        , EMAIL
        , PHONE_NUMBER
        , CREATED_AT::timestampntz as created_at_utc
        , UPDATED_AT::timestampntz as updated_at_utc
        , ADDRESS_ID
    from src
)

select * from renamed_recast