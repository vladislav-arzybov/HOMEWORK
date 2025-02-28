# Домашнее задание к занятию «Резервное копирование баз данных»   - `Арзыбов Владислав`


*Задания, помеченные звёздочкой, — дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.*

---

### Задание 1. Резервное копирование

### Кейс
Финансовая компания решила увеличить надёжность работы баз данных и их резервного копирования. 

Необходимо описать, какие варианты резервного копирования подходят в случаях: 

1.1. Необходимо восстанавливать данные в полном объёме за предыдущий день.

- В данном случае подойдёт как создание полного бэкапа на ежедневной основе, так и инкреметное копирование с созданием полной копиии раз в неделю. Оба варианта имеют свои плюсы и минусы, всё зависит от количество свободного места для создания полных бэкапов, и SLA на полное воостановление БД.

1.2. Необходимо восстанавливать данные за час до предполагаемой поломки.

- Полный бэкап на ежедневной основе, инкреметное копирование раз в час. Также можно выполнять полное копирование БД каждые 12 часов, это сократит время на восстановление БД при её поломке в конце дня.

1.3.* Возможен ли кейс, когда при поломке базы происходило моментальное переключение на работающую или починенную базу данных.

*Приведите ответ в свободной форме.*

- Да, в случае если есть реплика БД, в случае поломки slave автоматически займет место мастера, также такнный способ позволить снимать копии БД с реплики, что дополнительно снизит нагрузку с основной БД.

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

Проверяем что создался новый файл журнала mysql-bin.000002:
- docker exec -it repmysql /bin/bash
- ls -l /var/log/mysql/

![изображение](https://github.com/user-attachments/assets/4299a7b2-4a4e-4e59-9cc1-88f13b6c757f)

Добавляем новые данные в таблицу city:
- docker exec -it repmysql mysql -p
- USE world;
- INSERT INTO city (name, countrycode, district, population) VALUES ('Test-Backup3', 'ABC', 'Test3', '44');
- INSERT INTO city (name, countrycode, district, population) VALUES ('Test-Backup4', 'DFG', 'Test4', '45');
- SELECT * FROM city;

![изображение](https://github.com/user-attachments/assets/aacbdb4a-5370-44cc-866b-1a3e3ecbd005)

Для создания инкреметной резервной копии необходимо завершить процесс записи в текущий журнал и сохранить его как своего рода точку восстановления данных:
- docker exec -it repmysql /bin/bash
- mysqladmin -uroot -p flush-logs
- ls -l /var/log/mysql/

![изображение](https://github.com/user-attachments/assets/ba3e607a-230c-4837-901b-c14dc2fbb27c)

После этого необходимо произвести порчу\удаление ьазы данных world:
- drop database world;
- SHOW databases;

![изображение](https://github.com/user-attachments/assets/f7a3690b-bb30-4d34-8eff-c453b030b261)

Повторно создадим БД world:
- CREATE database world;
- SHOW databases;

![изображение](https://github.com/user-attachments/assets/633bb9dd-aac0-4501-9f17-abe249b1d4bc)

Как видими таблица city в БД world сейчас отсутствует:

![изображение](https://github.com/user-attachments/assets/e2b7dd08-321c-4a19-b760-5768a055f465)

Восстановим её из ранее созданного полного бэкапа:

**mysql -u root -p world < full_backup.sql**

Как видим в таблице city были восстановлены данные из полного бэкапа, но те что были созданы после этого отсутсвуют:

![изображение](https://github.com/user-attachments/assets/dd4b40cf-13e6-4651-a566-d03c8b7b4dc5)

Для восстановлени инкреметной резервной копии необходимо восстановить данные из двоичного журнала, сохранённого в файле mysql-bin.000002:

**mysqlbinlog /var/log/mysql/mysql-bin.000002 | mysql -uroot -p world**

![изображение](https://github.com/user-attachments/assets/da3b082a-40d1-4c53-bc30-b6924e68dd79)

*P.S. дополнительно пришлось копировать mysqlbinlog с образа mysql:8.0.23, т.к. в mysql:8.3 он по какой-то причине отсутствет.*

3.1.* В каких случаях использование реплики будет давать преимущество по сравнению с обычным резервным копированием?

*Приведите ответ в свободной форме.*

- Если основная база данных выйдет из строя, можно быстро переключиться на реплику и продолжить работу не тратив время на восстановление БД;
- Также реплику можно использовать как источний для снятия резервной копии БД, что положительно скажется как на уменьшении нагрузки, так и на простое основной БД.

---

