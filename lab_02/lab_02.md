# Лабораторная работа 2: Агрегация данных в SQL

Номер вариант 7

## Цель работы
Освоить методы объединения таблиц (JOIN, UNION), работу с подзапросами и функции преобразования данных (CASE, COALESCE) в PostgreSQL.

---

# Задания

## Задание 2.1: вывести модель товара и штат (state) клиента, купившего этот товар.

Модернизация запроса: добавлено географическое условие для опттимизации выгрузки,

Скрипт для выволнения запроса:

```sql
select 
	p.product_type,
	p.model
from 
	sales s
	inner join products p on s.product_id = p.product_id
	inner join customers c on s.customer_id = c.customer_id
where c.state = 'LA';
```

Выполнение запроса представлено на скриншоте:

<img width="350" height="820" alt="image" src="https://github.com/user-attachments/assets/8d47b80c-f68d-474e-b977-ea7a8fc28d24" />

---

## Задание 2.2: найдите клиентов, которые живут в том же штате, где находится дилерский центр ID=5.

Модернизация запроса:
1. также для оптимизации добавлены гендерное условие и условие остуствие номера телефона;
2. скриншот выполнения SELECT.

Скрипт для выволнения запроса:

```sgl
SELECT DISTINCT 
	c.last_name, 
	c.first_name,
	c.email
FROM customers c
JOIN dealerships d ON c.state = d.state
WHERE d.dealership_id = 5 and c.gender = 'F' and phone is null
order by last_name;
```

Выполнение запроса представлено на скриншоте:

<img width="562" height="840" alt="image" src="https://github.com/user-attachments/assets/20c874bc-a70c-467d-aa7a-22829820a408" />

---

## Задание 2.3: замените все пустые значения в столбце suffix таблицы customers на пустую строку или 'N/A'.

Модернизация запроса: все действия направлены на таблицу-копию. 

Скрипт для выволнения запроса:

```sgl
create table customers_02 as
select * 
from customers;

UPDATE customers_02 
SET suffix = 'N/A' 
WHERE suffix IS NULL OR suffix = '';
```

Выполнение запроса представлено на скриншоте:

<img width="147" height="830" alt="image" src="https://github.com/user-attachments/assets/c5c294a0-d71a-4188-bf49-a43b50830b38" />

---

# Вывод

В ходе лабораторной работы были:

- выполнены запросы с использованием JOIN для объединения таблиц;

- использована конструкция CASE для классификации данных по заданным условиям.

Все задания выполнены в соответствии с вариантом.  
Файл [lab_2.sql](lab_2.sql) содержит чистый код выполненных запросов.

