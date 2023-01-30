with orders as (
    select * from {{ ref ('stg_postgres__orders') }}
)
, addresses as (
    select * from {{ ref ('stg_postgres__addresses') }}
)
, promos as (
    select * from {{ ref ('stg_postgres__promos') }}
)

select
	orders.order_id
	, orders.user_id
	, orders.promo_desc
	, promos.discount
	, promos.status
	, orders.address_id
	, addresses.street_address
	, addresses.zipcode
	, addresses.state
	, addresses.country
	, orders.order_created_at_utc
	, orders.order_cost
	, orders.shipping_cost
	, orders.order_total
	, orders.tracking_id
	, orders.shipping_service
	, orders.order_estimated_delivery_at_utc
	, orders.order_delivered_utc
	, orders.order_status
from orders
left join addresses
    on addresses.address_id = orders.address_id
left join promos
    on promos.promo_desc = orders.promo_desc