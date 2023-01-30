with users as (
    select * from {{ ref ('stg_postgres__users') }}
)
, addresses as (
    select * from {{ ref ('stg_postgres__addresses') }}
)

select
    users.user_id
	, users.first_name
	, users.last_name
	, users.user_email
	, users.phone_number
	, users.user_created_at_utc
	, users.user_updated_at_utc
	, users.address_id
	, addresses.street_address
	, addresses.zipcode
	, addresses.state
	, addresses.country
from users
left join addresses
    on addresses.address_id = users.address_id