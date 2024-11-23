# Домашнее задание к занятию «Резервное копирование баз данных»


*Задания, помеченные звёздочкой, — дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.*

---

### Задание 1. Резервное копирование

### Кейс
Финансовая компания решила увеличить надёжность работы баз данных и их резервного копирования. 

Необходимо описать, какие варианты резервного копирования подходят в случаях: 

1.1. Необходимо восстанавливать данные в полном объёме за предыдущий день.

1.2. Необходимо восстанавливать данные за час до предполагаемой поломки.

1.3.* Возможен ли кейс, когда при поломке базы происходило моментальное переключение на работающую или починенную базу данных.

*Приведите ответ в свободной форме.*

---

### Задание 2. PostgreSQL

2.1. С помощью официальной документации приведите пример команды резервирования данных и восстановления БД (pgdump/pgrestore).

Создаем резервную копию:

**pg_dump -U postgres -W books > /tmp/books.dump**

![изображение](https://github.com/user-attachments/assets/cd39048b-0936-4bef-b1ce-d6645b92d588)

![изображение](https://github.com/user-attachments/assets/1dcd077b-4fd2-4cd9-95c8-5e0e33fa2b37)

Удалим данные в таблице books

![изображение](https://github.com/user-attachments/assets/2d3305e4-e26c-443d-9d19-cd4455c7a7b1)




Восстановление БД:

**psql -U postgres -d books < /tmp/books.dump**

![изображение](https://github.com/user-attachments/assets/cf4708ee-c279-43f7-a3a6-b513eea952ad)

Проверяем данные в БД:

![изображение](https://github.com/user-attachments/assets/fe44a461-631d-4009-b6d7-2bf4ca94388b)


2.1.* Возможно ли автоматизировать этот процесс? Если да, то как?

*Приведите ответ в свободной форме.*

Можножно использовать скрипт:

```bash
#!/bin/bash
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

PGPASSWORD=postgres
export PGPASSWORD
pathB=/mnt/backup
dbUser=postgres
database=books

pg_dump -U $dbUser $database | gzip > $pathB/pgsql_$(date "+%Y-%m-%d").sql.gz

unset PGPASSWORD
```

Добавить расписание в планировщик cron запускать скрипт ежедневно в 3 часа ночи:

```bash
3 0 * * * /etc/scripts/pgsql_dump.sh # postgres pg_dump
```


---

### Задание 3. MySQL

3.1. С помощью официальной документации приведите пример команды инкрементного резервного копирования базы данных MySQL. 

Для теста создадим docker-контейнер с mysql ver.8.3:
- docker run -d --name repmysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql:8.3

Отредактируем конфиг /etc/my.cnf, т.к. для выполнения инкрементного резервного копирования необходимо включить двоичный журнал.
- Добавим сроку: log_bin = /var/log/mysql/mysql-bin.log expire_logs_days = 10

![изображение](https://github.com/user-attachments/assets/00bdb0a6-0684-429a-8570-1f8e160ebda3)

Перезапустим контейнер:
- docker restart repmysql

Создадим БД, таблицу и наполним её данными:
- docker exec -it repmysql mysql -p
- CREATE database world;
- SHOW databases;
- USE world;
- CREATE TABLE city (id SERIAL PRIMARY KEY, name VARCHAR(50), countrycode VARCHAR(50), district VARCHAR(50), population INTEGER);
- INSERT INTO city (name, countrycode, district, population) VALUES ('Test-Replication', 'ALB', 'Test', '42');
- INSERT INTO city (name, countrycode, district, population) VALUES ('Test-Backup', 'CRT', 'Test2', '43');
- SELECT * FROM city;

![изображение](https://github.com/user-attachments/assets/482c988e-fadd-48c9-a1ec-a77d30a1bf72)

Выполним полный бэкап:

**mysqldump -uroot -p --all-databases --single-transaction --flush-logs --master-data=2 > full_backup.sql**



3.1.* В каких случаях использование реплики будет давать преимущество по сравнению с обычным резервным копированием?

*Приведите ответ в свободной форме.*

---

