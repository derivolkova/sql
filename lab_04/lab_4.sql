-- 4.1 	Ранжировать клиентов (customers) по алфавиту имени (first_name) внутри каждого штата (state).

select 
	first_name,
	last_name,
	state,
	row_number() over (partition by state order by first_name) as rank
from customers 
where state is not null 
order by 
 	state, rank
 -- введены дополнительное условие, так как без ниго в выгрузке 100000 записей, а с ним - 89066

 -- 4.2 Разделить все продукты на 10 ценовых категорий (NTILE) на основе base_msrp.

select distinct -- добавлен тк некоторые моедли повторялись
 	product_id,
	product_type,
	base_msrp,
	ntile(10) over (order by base_msrp) as category
from products
order by category asc, base_msrp asc  -- по ценовой категории, а внутри этих групп по цене

-- 4.3 Рассчитать минимум и максимум продаж (sales_amount) в скользящем окне (5 последних транзакций) для каждого дилера.
select 
	dealership_id,
	sales_transaction_date,
	min(sales_amount) over (partition by dealership_id order by sales_transaction_date 
rows between 4 preceding and current row ) as min_sales,
	max(sales_amount) over (partition by dealership_id order by sales_transaction_date 
rows between 4 preceding and current row ) as max_sales
from sales
where dealership_id is not null
order by sales_transaction_date, min_sales
limit 20
-- без дополнительных условия в выгрузке 33296 строк, а с условиями - 20