{% set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}

with events as (
    select * from {{ ref('stg_postgres__events')}}
)
, order_products as (
    select * from {{ ref('int_user_order_product')}}
)
, session_dates as (
    select * from {{ ref('int_session_dates') }}
)
, user_product_sessions as (
    select 
        events.session_id
        , events.user_id
        , coalesce(events.product_id, order_products.product_id) as product_id
        {% for event_type in event_types %}
        , {{ sum_of('events.event_type', event_type) }} as {{ event_type }}
        {% endfor %}
    from events
    left join order_products
        on order_products.order_id = events.order_id
    group by 1,2,3
)

select
    user_product_sessions.session_id
    , user_product_sessions.user_id
    , user_product_sessions.product_id
    , session_dates.session_start_utc
    , session_dates.session_end_utc
    , user_product_sessions.page_view
    , user_product_sessions.add_to_cart
    , user_product_sessions.checkout
    , user_product_sessions.package_shipped
from user_product_sessions
left join session_dates on
    session_dates.session_id = user_product_sessions.session_id
