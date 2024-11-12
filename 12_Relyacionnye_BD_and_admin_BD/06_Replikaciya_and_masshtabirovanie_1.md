# Домашнее задание к занятию «Репликация и масштабирование. Часть 1» - `Арзыбов Владислав`


---

### Задание 1

На лекции рассматривались режимы репликации master-slave, master-master, опишите их различия.

*Ответить в свободной форме.*

- В режиме репликации master-slave поток данных односторонний, от master к slave, в то время как в режиме master-master он двунаправленный.
- В режиме master-slave только master может записывать данные, и только со slave данные доступны для чтения, в то время как в режиме master-master оба мастера могут как записывать так и выполнять операции чтения.
- Реализация master-slave проще, также в ней меньше вероятность возникновения конфликтов из-за одностороннего потока данных.
- В то же время в случае выхода одного из master серверов в режиме master-master происходит автоматическое переключение на другой master сервер, в отличии от режима master-slave, где в случае сбоя slave сервер должен быть повышен до уровня master'a, автоматическое переключение не предусмотрено.

---

### Задание 2

Выполните конфигурацию master-slave репликации, примером можно пользоваться из лекции.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

- docker run -d --name replication-master -e MYSQL_ROOT_PASSWORD=123456 -d mysql:8.3
- docker run -d --name replication-slave -e MYSQL_ROOT_PASSWORD=123456 -d mysql:8.3
- docker ps

![изображение](https://github.com/user-attachments/assets/25f0128b-d458-435e-838d-5d9f4ef7151d)

Создадим сеть:
- docker network create replication
- docker network connect replication replication-master
- docker network connect replication replication-slave

Создадим учетную запись master для сервера репликации:
- docker exec -it replication-master mysql -p
- CREATE USER 'replication'@'%';
- GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
- SHOW GRANTS FOR replication@'%';

![изображение](https://github.com/user-attachments/assets/2bd3d14f-1799-45e8-8b8e-fda9d4c96b2e)

Вносим изменения в файл /etc/my.cnf на сервере replication-master
![изображение](https://github.com/user-attachments/assets/2783d37c-e81f-4dfb-bd7e-bc19b875cc3d)

Выполняем перезагрузку и проверяем состояние мастер сервера:
- docker restart replication-master
- SHOW MASTER STATUS;

![изображение](https://github.com/user-attachments/assets/514ecb21-99e5-4c21-9f93-cbf33b02cdcf)

Вносим изменения в файл /etc/my.cnf на сервере replication-slave

![изображение](https://github.com/user-attachments/assets/5731c44a-06d9-4ed8-ac59-54e8fdd64a8a)

Выполняем перезагрузку и послеующую настройку сервера реплики:
- docker restart replication-slave
- CHANGE MASTER TO
MASTER_HOST='replication-master',
MASTER_USER='replication',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=158;

![изображение](https://github.com/user-attachments/assets/8a99ca97-4d67-49dd-86cd-32cd4b68d656)

- START REPLICA;
- SHOW SLAVE STATUS\G

![изображение](https://github.com/user-attachments/assets/5551b101-9483-4063-97da-e9bfb81337af)

# Тестирование

Создаем новую БД и таблицу на сервере replication-master:
- CREATE database world;
- SHOW databases;
- USE world;
- CREATE TABLE city (id SERIAL PRIMARY KEY, name VARCHAR(50), countrycode VARCHAR(50), district VARCHAR(50), population INTEGER);
- INSERT INTO city (id, name, countrycode, district, population) VALUES ('1', 'Test-Replication', 'ALB', 'Test', '42');
- SELECT * FROM city ORDER BY ID DESC LIMIT 1;

![изображение](https://github.com/user-attachments/assets/f1090b1c-ecc8-4ee7-9d3f-74806fe97e71)

- SHOW MASTER STATUS;

![изображение](https://github.com/user-attachments/assets/ae5d4754-32cf-4825-a4f5-2fb6c60d9f2a)


Проверяем наличие БД и записей в таблице на сервере replication-slave:
- SHOW SLAVE STATUS\G

![изображение](https://github.com/user-attachments/assets/fad1d4f5-29ab-4584-b77c-a5893f4bd81a)

- SHOW databases;
- USE world;
- SHOW tables;
- SELECT * FROM city ORDER BY ID DESC LIMIT 1;

![изображение](https://github.com/user-attachments/assets/c1e4f806-ef04-4cb9-ab6b-2ac02e394ebc)


---

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*

- docker run -d --name replication-master-one -e MYSQL_ALLOW_EMPTY_PASSWORD=true -v ~/path/to/world/dump:/docker-entrypoint-initdb.d mysql:8.0
- docker run -d --name replication-master-two -e MYSQL_ALLOW_EMPTY_PASSWORD=true -v ~/path/to/world/dump:/docker-entrypoint-initdb.d mysql:8.0
- docker ps

![изображение](https://github.com/user-attachments/assets/4e0fe0af-fd50-43be-bf23-67e6feb7b925)

Создадим сеть replication и добавим в неё наши сервера:
- docker network create replication
- docker network connect replication replication-master-one
- docker network connect replication replication-master-two

Вносим и проверяем изменения в файле /etc/my.cnf на серверах replication-master-one и replication-master-two:
- docker exec -it replication-master-one cat /etc/my.cnf

![изображение](https://github.com/user-attachments/assets/4cc108ac-98c5-40cd-a71d-860779b15e5e)

- docker exec -it replication-master-two cat /etc/my.cnf

![изображение](https://github.com/user-attachments/assets/1e5ccaaf-9cf7-4786-95b6-7e852334808b)

Выполняем настройку сервера replication-master-two:
- stop slave;
- CHANGE MASTER TO MASTER_HOST = 'replication-master-one', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
- start slave;
  
![изображение](https://github.com/user-attachments/assets/b83de067-38a0-4c2b-b05e-d844f52c26f7)

Выполняем настройку сервера replication-master-one:
- stop slave;
- CHANGE MASTER TO MASTER_HOST = 'replication-master-two', MASTER_USER = 'replicator', MASTER_PASSWORD = 'password', MASTER_LOG_FILE = 'mysql-bin.000001', MASTER_LOG_POS = 107;
- CHANGE MASTER TO GET_MASTER_PUBLIC_KEY=1;
- start slave;

![изображение](https://github.com/user-attachments/assets/13255e86-5b00-452d-b538-c7ddf11b332c)

Создаем пользователя replicator на обоих серверах:
- create user 'replicator'@'%' identified by 'password';
- create database example;
- grant replication slave on *.* to 'replicator'@'%';
- SELECT user FROM mysql.user;

![изображение](https://github.com/user-attachments/assets/3853ac48-ce60-49df-b9c7-4829416f23b8)

Перезагружаем сервера:
- docker restart replication-master-one
- docker restart replication-master-two

Проверяем статус на обоих серверах:
- SHOW MASTER STATUS;

![изображение](https://github.com/user-attachments/assets/93ae7d85-2014-4eb2-a17f-39d10d64c8d9)

# Тестирование

Создаем новую БД и таблицу на сервере replication-master-one:
- CREATE database world;
- SHOW databases;
- USE world;
- CREATE TABLE city (id SERIAL PRIMARY KEY, name VARCHAR(50), countrycode VARCHAR(50), district VARCHAR(50), population INTEGER);
- INSERT INTO city (id, name, countrycode, district, population) VALUES ('1', 'Test-Replication', 'ALB', 'Test', '42');
- SELECT * FROM city ORDER BY ID DESC LIMIT 1;

![изображение](https://github.com/user-attachments/assets/c32a3c9d-5af6-4700-8ad2-6e0914ba60e5)

- SHOW MASTER STATUS;

![изображение](https://github.com/user-attachments/assets/d2468315-12e4-4894-914b-55d25a7114d7)


Проверяем наличие БД и записей в таблице на сервере replication-master-two:
- SHOW SLAVE STATUS\G

![изображение](https://github.com/user-attachments/assets/90da9fe9-fbc8-4c63-98be-2c214ca2c665)

- SHOW databases;
- USE world;
- SHOW tables;
- SELECT * FROM city ORDER BY ID DESC LIMIT 1;

![изображение](https://github.com/user-attachments/assets/e577ae0d-39b1-443e-a754-ec99894f627f)

