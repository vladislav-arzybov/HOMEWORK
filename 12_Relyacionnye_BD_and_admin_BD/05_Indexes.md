# Домашнее задание к занятию «Индексы» - `Арзыбов Владислав`

### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.
```sql
SELECT table_schema as 'Имя БД',
ROUND((SUM(index_length))*100/(SUM(data_length+index_length)),0) 'Процент'
FROM information_schema.TABLES
WHERE table_schema = 'sakila';
```

![изображение](https://github.com/user-attachments/assets/de31076e-cdc4-44be-894e-49e763868ae7)


### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;

*Запрос выводит данные о покупателях и сумме платежей за указанную дату. В запросе много лишних таблиц которые не участвуют в итоговом выводе, такие как rental, inventoryfilm.*

*Кратко его можно представить в виде такого sql скрипта:*

```sql
select p.*, concat(c.last_name, ' ', c.first_name) from payment p
join customer c on p.customer_id = c.customer_id
where date(p.payment_date) = '2005-07-30';
```

*До оптимизации скрипт выполнялся за 6,5 сек*

![изображение](https://github.com/user-attachments/assets/44374fea-2903-48e8-87b7-3be1d5dc4a9d)
 
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

  *Запрос оптимизирован, удалены ненужные таблицы:*
  
```sql
select distinct concat(c.last_name, ' ', c.first_name) as 'Покупатель', sum(p.amount) over (partition by c.customer_id) as 'Сумма'
from payment p
join customer c on p.customer_id = c.customer_id
where date(p.payment_date) = '2005-07-30';
```

![изображение](https://github.com/user-attachments/assets/53e84e47-dca4-4923-b12d-93b9da1ae414)

  *Добавлен индекс:*

```sql
CREATE INDEX index_payment_date ON payment (payment_date);
```

![изображение](https://github.com/user-attachments/assets/23ea4beb-2f94-4f84-b203-eeabe6f9f905)

  *Итоговое время выполнения 8,5 млсек:*

  ![изображение](https://github.com/user-attachments/assets/bc3512ff-c226-4f9b-87ed-e2509545a4be)


## *Дополнительная доработка скрипта*

```sql
select distinct concat(c.last_name, ' ', c.first_name) as 'Покупатель', sum(p.amount) as 'Сумма'
from payment p
inner join customer c on p.customer_id = c.customer_id
where p.payment_date >= '2005-07-30' and p.payment_date < DATE_ADD('2005-07-30', INTERVAL 1 DAY)
group by c.customer_id;
```

![изображение](https://github.com/user-attachments/assets/7d734282-9171-46ae-a338-4e579cf739e7)



## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 3*

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*

Индексы которых нет в MySQL:

   **- Частичные индексы.** Упорядочивают информацию только из части таблицы.
    
   **- Индексы выражений.** Вычисляются из функций, а не из значений в столбцах таблицы.
    
   **- GiST и SP-GiST индексы.** Позволяют, например, находить все точки, находящиеся внутри заданного круга, и сортировать геоданные.
    
   **- GIN индексы.** Предназначены для работы с типами, которые могут содержать более одного значения. Например, с их помощью можно найти все массивы, содержащие заданный элемент.
    
   **- BRIN индексы.** Используются для хранения краткого описания значений на последовательных страницах физических данных внутри таблицы.

