{{
  config(
    materialized='table'
  )
}}

select 
    user_id
  , user_email
  , user_created_at_utc
  , user_updated_at_utc
  , stg_users.address_id
  , full_address
  , zipcode
  , state
  , country
from {{ ref('stg_postgres__users') }} stg_users
left join {{ref('stg_postgres__addresses')}} using (address_id)