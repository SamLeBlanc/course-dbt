with orders as (
    select *
    from {{ ref ('stg_postgres__orders') }}
)
, addresses as (
    select *
    from {{ ref ('stg_postgres__addresses') }}
)
, promos as (
    select *
    from {{ ref ('stg_postgres__promos') }}
)

select
	o.order_id
	, o.user_id
	, o.promo_desc
	, p.discount
	, p.status
	, o.address_id
	, a.street_address
	, a.zipcode
	, a.state
	, a.country
	, o.order_created_at_utc
	, o.order_cost
	, o.shipping_cost
	, o.order_total
	, o.tracking_id
	, o.shipping_service
	, o.order_estimated_delivery_at_utc
	, o.order_delivered_utc
	, o.order_status
from orders o
left join addresses a
    on a.address_id = o.address_id
left join promos p
    on p.promo_desc = o.promo_desc