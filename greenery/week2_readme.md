
What is our user repeat rate? (Repeat Rate = Users who purchased 2 or more times / users who purchased)

- 79.8%

```
with source as (
    select 
        user_id
        , count(*) as total_orders 
    from stg_postgres__orders
    group by 1
    order by 2 desc
)
select 
    count(distinct case when total_orders > 1 then user_id end) as repeat_users, 
    count(user_id) as total_users, 
    repeat_users / total_users*100 as repeat_rate 
from source
```

What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

- Re-purchase indicators
  - Many page views
  - Left good reviews
  - Purchasing products that other repeat useres buy
- Single purchase indicators
  - Few page views
  - Bad reviews
  - Small time on website
  - Promos maybe? becuase people are looking for the cheapest place to purchase regardless of vendor
- New features
  - Relationships of clicked items
  - Total cart size (big $penders)
  - Time spent with item in cart

Explain the marts models you added. Why did you organize the models in the way you did?
- My goal was to organize the models in a way that would help me aggregate data effectively, as is the purpose of dbt :D The first model I focuesed on was the dim_users model, which included all of the relevant user information including address, which was previously in its own model. Then, I created the intermediate models int_orders and int_order_items which I could use to create the fact_orders and fact_order_items models. These intermediate models were helpful because they split out the order/product matching which shouldn't be in the staging section. Additionally, to understand inventory and product information, I began by creating the int_user_sessions and int_user_product_sessions. These models aggregate views, carts, checkouts, and shipping information for each user and session. From there, it was easy to make the fact_product and fact_product_sessions_daily to understand inventory and order information at a product granularity.

What assumptions are you making about each model? (i.e. why are you adding each test?)
- The assumptions are that primary keys should by unique and not null (thats like, their thing). If this were not the case, there would be massive issues in the consistency and accuracy of our aggregation queries.

Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
- There were certain IDs (not primary keys) that I expected to be not null, so I initially created those tests. However, there was a small number of rows that had a null ID. I was unsure of whether to remove that data or to change the test. In a real world scenario I may have better understanding of what to do with these rows but for now, I removed my not null tests since I didn't want to cut any of the data.

Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
- I would set up a notification system, Slack or email, that would inform the team of the result of the tests/runs each day. If a test fails, the team gets a notification and knows to check the data stream.


