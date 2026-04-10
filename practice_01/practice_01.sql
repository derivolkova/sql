--1 
select
    extract(DOW from sales_transaction_date) as day_of_week_number,
    case extract(DOW from sales_transaction_date)
        when 0 then 'Sunday'
        when 1 then 'Monday'
        when 2 then 'Tuesday'
        when 3 then 'Wednesday'
        when 4 then 'Thursday'
        when 5 then 'Friday'
        when 6 then 'Saturday'
    end as day_of_week_name,
    count(*) as number_of_sales
from sales
group by extract(DOW from sales_transaction_date)
order by number_of_sales desc;

--2
select 
    d.dealership_id,
    d.name,
    count(*) as customers_in_radius
from dealerships d
cross join customers c
where (point(c.longitude, c.latitude) <@> point(d.longitude, d.latitude)) < 100
group by d.dealership_id, d.name
order by customers_in_radius desc
limit 1;

--3
select 
    sum((elem ->> 'sales_amount')::numeric) as total_sales
from customer_sales,
jsonb_array_elements(customer_json -> 'sales') as elem;

--4

select 
    rating,
    avg(array_length(string_to_array(feedback, ' '), 1)) as avg_words_per_review
from customer_survey
where feedback is not null
group by rating
order by rating;