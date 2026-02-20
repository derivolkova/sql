
-- 2 лабораторная, вариант 7

--2.1 Вывести модель товара и штат (state) клиента, купившего этот товар.
-- без доп условия выгрузка содержит 37711 записей, поэтому было принято решение допавить географическое условие (665 записей)
select 
	p.product_type,
	p.model
from 
	sales s
	inner join products p on s.product_id = p.product_id
	inner join customers c on s.customer_id = c.customer_id
where c.state = 'LA';
-- штат не вывожу, так как он прописан в условии.

-- 2.2 Найдите клиентов, которые живут в том же штате, где находится дилерский центр ID=5
-- без доп условия выгрузка содержит 5038 записей, поэтому было принято решение допавить гендерное условие и обязательное поле - остуствие номера телефона (753 записей)

SELECT DISTINCT 
	c.last_name, 
	c.first_name,
	c.email
FROM customers c
JOIN dealerships d ON c.state = d.state
WHERE d.dealership_id = 5 and c.gender = 'F' and phone is null
order by last_name;
-- гендер не выведен, так как он прописан в условии, колонка номера - так как поле примет значение null. Выгрузка получается эффективной для (условно) написания писем женщинам сразу на почту

	
-- 2.3 Замените все пустые значения встолбце suffix таблицы customers на пустую строку или 'N/A'.
-- создаем копию таблицы, чтобы не портить основную
create table customers_02 as
select * 
from customers;

UPDATE customers_02 
SET suffix = 'N/A' 
WHERE suffix IS NULL OR suffix = ''; -- все пустые и нулевые значения изменяются

-- проверка
select suffix 
from customers_02
where suffix = ''; -- результат null

select suffix 
from customers_02
where suffix is null; -- результат null

select suffix 
from customers_02
where suffix = 'N/A'; -- 49468 значений




