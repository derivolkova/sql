# Практическая работа 1. Геопространственный анализ данных. Аналитика с использованием сложных типов данных.

## Цель работы
Научиться применять продвинутые возможности PostgreSQL для анализа данных, выходящих за рамки стандартных чисел и строк. Освоить работу с временными рядами, геопространственными данными, массивами, JSON/JSONB структурами и полнотекстовым поиском.

## Задачи
1. Анализ временных рядов. Использование функций DATE_TRUNC, EXTRACT, INTERVAL для агрегации продаж по периодам.
2. Геопространственный анализ. Установка расширений cube и earthdistance, расчет расстояний между клиентами и дилерскими центрами, поиск ближайших объектов.
3. Работа со сложными структурами. Формирование и разбор массивов (ARRAY), генерация и запрос данных в формате JSON/JSONB.
4. Текстовая аналитика. Токенизация текста, очистка от знаков препинания, частотный анализ слов в отзывах клиентов.

## Блок А. Дни недели продаж. Определите, в какой день недели (понедельник, вторник и т.д.) совершается наибольшее количество продаж (sales). Выведите день недели и количество транзакций.

```sql
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
```

<img width="503" height="269" alt="image" src="https://github.com/user-attachments/assets/532ecda2-14c0-48e9-89b3-1ed98ca15b18" />

## Блок Б. Покрытие дилеров. Найдите дилерский центр, у которого наибольшее количество клиентов в радиусе 100 миль.

```sql
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
```

<img width="311" height="86" alt="image" src="https://github.com/user-attachments/assets/c3ebe778-79d8-4639-9055-843e7407d6dc" />

## Блок В. Извлечение из JSON. Из таблицы customer_sales извлеките поле sales (массив внутри JSON), разверните его (jsonb_array_elements) и посчитайте общую сумму продаж, хранящуюся внутри JSON.

```sql
select 
    sum((elem ->> 'sales_amount')::numeric) as total_sales
from customer_sales,
jsonb_array_elements(customer_json -> 'sales') as elem;
```

<img width="148" height="82" alt="image" src="https://github.com/user-attachments/assets/198b99cd-4b75-4463-b68b-507726264eaa" />

## Блок Г. Сравнение длины. Определите, есть ли корреляция между длиной отзыва (количество слов) и оценкой (rating). Выведите среднюю длину отзыва для каждой оценки.

```sql
select 
    rating,
    avg(array_length(string_to_array(feedback, ' '), 1)) as avg_words_per_review
from customer_survey
where feedback is not null
group by rating
order by rating;
```

<img width="281" height="361" alt="image" src="https://github.com/user-attachments/assets/6ea1b1a6-9aef-4f9c-95d8-5f72e66610bb" />

[Файл](practice_01.sql)

## Выводы по работе
В ходе выполнения практической работы были изучены и применены продвинутые возможности PostgreSQL для анализа данных различных типов.


