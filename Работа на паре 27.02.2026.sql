-- Упражнение 1. Анализ показателей заполнения клиентских данных с течением времени
SELECT customer_id, street_address, date_added:: DATE,
COUNT (CASE WHEN street_address IS NOT NULL THEN customer_id ELSE NULL END)
OVER (ORDER BY date_added:: DATE) as total_customers_filled_street
FROM customers
ORDER BY date_added;

-- Упражнение 2. Порядок приема на работу
SELECT *,
RANK() OVER (PARTITION BY dealership_id
ORDER BY hire_date)
FROM salespeople
WHERE termination_date IS NULL;

-- Упражнение 3. Обеденная мотивация команды
WITH daily_sales as (SELECT sales_transaction_date::DATE,
SUM(sales_amount) as total_sales
FROM sales
GROUP BY 1
),
sales_stats_30 AS (
SELECT sales_transaction_date, total_sales,
MAX (total_sales) OVER (ORDER BY sales_transaction_date ROWS BETWEEN 30
PRECEDING and 1 PRECEDING)
AS max_sales_30
FROM daily_sales
ORDER BY 1)
SELECT sales_transaction_date, total_sales, max_sales_30
FROM sales_stats_30
WHERE sales_transaction_date>='2019-01-01';

-- Практическое задание 4.
-- Задание 1. Ранжирование
-- Условие. Ранжировать штаты по количеству дилерских центров (от большего к меньшему).
SELECT state,
COUNT (dealership_id) As dealer_count,
RANK() OVER (ORDER BY
COUNT (dealership_id) DESC) as state_rank
FROM dealerships
GROUP BY state;

-- Задание 2. Смещение и сравнение
-- Условие. Сравнить дату добавления клиента с датой добавления предыдущего клиента с тем же именем (first_name).
SELECT
customer_id, 
first_name, 
date_added,
LAG(date_added) OVER (PARTITION BY first_name ORDER BY date_added) as prev_date_same_name
FROM customers
ORDER BY first_name, date_added;

-- Задание 3. Агрегация с окном
-- Условие. Скользящая сумма (нарастающий итог) базовой цены (base_msrp) всех доступных продуктов, упорядоченных по ID.
SELECT 
product_id,
model,
base_msrp,
SUM(base_msrp) OVER (ORDER BY product_id) as running_total_price
FROM products
WHERE production_end_date IS NULL;