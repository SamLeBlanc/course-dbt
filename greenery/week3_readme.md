### What is our overall conversion rate?

- 62.4%

```
with base as (
    select 
        count(distinct session_id) as total_sessions,
        count(distinct case when checkout > 0 then session_id end) as sessions_with_checkout
    from fct_user_sessions
)

select div0(sessions_with_checkout, total_sessions) as conversion_rate from base;
```

### What is our conversion rate by product?

```
with base as (
    select 
        product_id,
        count(distinct session_id) as total_sessions,
        count(distinct case when package_shipped > 0 then session_id end) as sessions_with_checkout
    from fct_user_sessions
    group by 1
)

select
    p.product_name,
    div0(base.sessions_with_checkout, base.total_sessions) as conversion_rate
from base
left join dim_products p on p.product_id = base.product_id
order by product_name;
```
[Head]
PRODUCT_NAME	CONVERSION_RATE
Alocasia Polly	0.392156
Aloe Vera	0.430769
Angel Wings Begonia	0.344262
Arrow Head	0.507936

### Which orders changed from week 2 to week 3? 

I think this is for both week 2 and week 3 since I didn't get this part last week.

265f9aae-561a-4232-a78a-7052466e46b7
e42ba9a9-986a-4f00-8dd2-5cf8462c74ea
b4eec587-6bca-4b2a-b3d3-ef2db72c4a4f
29d20dcd-d0c4-4bca-a52d-fc9363b5d7c6
c0873253-7827-4831-aa92-19c38372e58d
e2729b7d-e313-4a6f-9444-f7f65ae8db9a