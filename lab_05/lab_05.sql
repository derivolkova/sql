--1
explain analyze 
select * from products
where model = 'Lemon'

--2

create index idx_hash 
on products using HASH (model);

set enable_seqscan = off;

explain analyze 
select * from products
where model = 'Lemon'


--3
explain analyze 
select *from sales s
join products p on s.product_id = p.product_id
join customers c on s.customer_id = c.customer_id
where s.channel = 'internet' and model = 'Bat' and sales_transaction_date::date = '2019-04-07' and s.sales_amount = 479.992;

create index idx_sales_internet 
on sales (sales_transaction_date, sales_amount) 
where channel = 'internet';

explain analyze 
select *from sales s
join products p on s.product_id = p.product_id
join customers c on s.customer_id = c.customer_id
where s.channel = 'internet' and model = 'Bat' and sales_transaction_date::date = '2019-04-07' and s.sales_amount = 479.992;
