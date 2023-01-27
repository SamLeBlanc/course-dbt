with src as (
    select * from {{source('postgres','users')}}
)

, renamed_recast as (
    select 
        USER_ID
        , FIRST_NAME
        , LAST_NAME
        , EMAIL as user_email
        , PHONE_NUMBER
        , CREATED_AT::timestampntz as user_created_at_utc
        , UPDATED_AT::timestampntz as user_updated_at_utc
        , ADDRESS_ID
    from src
)

select * from renamed_recast