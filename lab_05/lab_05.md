# Лабораторная работа 5. Оптимизация запросов с помощью индексов и анализа плана выполнения.

Вариант 7

## Цель работы
Научиться анализировать производительность SQL-запросов, интерпретировать план выполнения (Query Plan) и оптимизировать работу базы данных с помощью различных типов инксов (B-tree, Hash).

## Задание 1. Анализ текущей производительности

```sql
explain analyze 
select * from products
where model = 'Lemon'
```

<img width="727" height="294" alt="image" src="https://github.com/user-attachments/assets/da07dcab-d630-4674-8789-b4b61818d2ac" />

**Запрос выполнил полное сканирование таблицы (Seq Scan), отфильтровав 20 строк из 24,время выполнения составило 0.257 мс., но при росте объема данных такой план станет неэффективным**

## Задание 2.  Оптимизация

*Создание hash-индекса*

```sql
create index idx_hash 
on products using HASH (model);
```

*Анализ производительности запроса* 

```sql
explain analyze 
select * from products
where model = 'Lemon'
```
<img width="859" height="233" alt="image" src="https://github.com/user-attachments/assets/d277b492-c182-4644-9eb5-136db996202f" />

**Hash-индекс работает исправно, но для маленькой таблицы он оказался менее эффекитвным, чем просто просмотр всех данных. 
Индекс даст ускорение на таблицах с большим количеством данных.**

## Задание 3. Оптимизировать поиск продаж по channel = 'internet'.

```sql
explain analyze 
select * from sales s
join products p on s.product_id = p.product_id
join customers c on s.customer_id = c.customer_id
where s.channel = 'internet'
```
<img width="1155" height="833" alt="image" src="https://github.com/user-attachments/assets/82bc1b6f-19e8-43c6-9eb1-52dfd51cc200" />

**Запрос медленный (117 мс), потому что PostgreSQL просматривает все 75 тысяч строк в таблице sales, хотя нужны только интернет-продажи. Нужен индекс на channel, чтобы искать сразу нужные строки.**

*Создание индексов*

```sql
create index idx_sales_internet 
on sales (sales_transaction_date, sales_amount) 
where channel = 'internet';
```

*Анализ*
```sql
explain analyze 
select * from sales s
join products p on s.product_id = p.product_id
join customers c on s.customer_id = c.customer_id
where s.channel = 'internet'
```
<img width="1148" height="822" alt="image" src="https://github.com/user-attachments/assets/18834b31-fc36-40ed-bc96-71d5f8bf23df" />

**Время 120 мс (было 171 мс). Hash Join работает быстрее, чем Merge Join.**

## Выводы
В ходе лабораторной работы было установлено, что эффективность индексов напрямую зависит от объема данных: на маленькой таблице (24 строки) последовательное сканирование оказалось быстрее индексного (0.257 мс против 12.113 мс) из-за накладных расходов на работу с индексом. На больших таблицах индекс ускоряет фильтрацию, но не всегда улучшает общее время выполнения запроса, так как основная нагрузка может приходиться на соединение таблиц (JOIN). Создание составного индекса привело к смене плана с Hash Join на Merge Join и ухудшению времени до 171 мс, тогда как частичный индекс idx_sales_internet в сочетании с Hash Join показал наилучший результат — 120 мс. Таким образом, индексы требуют экспериментальной настройки через EXPLAIN ANALYZE, и оптимальное решение зависит от конкретных условий и объема данных.

