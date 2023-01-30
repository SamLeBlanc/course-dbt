{% set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}

with events as (
    select *
    from {{ ref('stg_postgres__events')}}
)
, order_products as (
    select *
    from {{ ref('int_user_order_product')}}
)
, session_dates as (
    select *
    from {{ ref('int_session_dates') }}
)
, user_product_sessions as (
    select 
        e.session_id
        , e.user_id
        , coalesce(e.product_id, op.product_id) as product_id
        {% for event_type in event_types %}
        , {{ sum_of('e.event_type', event_type) }} as {{ event_type }}
        {% endfor %}
    from events e
    left join order_products op
        on op.order_id = e.order_id
    group by 1, 2, 3
)

select
    s.session_id
    , s.user_id
    , s.product_id
    , d.session_start_utc
    , d.session_end_utc
    , s.page_view
    , s.add_to_cart
    , s.checkout
    , s.package_shipped
from user_product_sessions s
left join session_dates d on
    d.session_id = s.session_id
