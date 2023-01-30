with users as (
    select *
    from {{ ref ('stg_postgres__users') }}
)
, addresses as (
    select *
    from {{ ref ('stg_postgres__addresses') }}
)

select
      u.user_id
	, u.first_name
	, u.last_name
	, u.user_email
	, u.phone_number
	, u.user_created_at_utc
	, u.user_updated_at_utc
	, u.address_id
	, a.street_address
	, a.zipcode
	, a.state
	, a.country
from users u
left join addresses a
    on a.address_id = u.address_id