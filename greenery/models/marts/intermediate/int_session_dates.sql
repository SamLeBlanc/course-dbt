with events as (
    select *
    from {{ ref('stg_postgres__events')}}
)
, session_dates as (
    select 
        session_id
        , min(created_at_utc) AS session_start_utc
        , max(created_at_utc) AS session_end_utc
    from events
    group by 1
)

select
    session_id
    , session_start_utc
    , session_end_utc
from session_dates