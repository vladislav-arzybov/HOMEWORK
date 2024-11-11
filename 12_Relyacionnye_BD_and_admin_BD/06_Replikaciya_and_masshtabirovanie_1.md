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




---

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

---

### Задание 3* 

Выполните конфигурацию master-master репликации. Произведите проверку.

*Приложите скриншоты конфигурации, выполнения работы: состояния и режимы работы серверов.*
