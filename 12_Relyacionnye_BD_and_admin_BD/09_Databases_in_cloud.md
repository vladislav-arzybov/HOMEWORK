# Домашнее задание к занятию «Базы данных в облаке»  - `Арзыбов Владислав`


### Цель задания

На лекции вы узнали, как работать с системами управления баз данных. Теперь вы поработаете над созданием кластера и проверке работоспособности репликации в кластере. В результате выполнения этого задания вы научитесь:

* создавать кластер PostgreSQL;

* подключаться к мастеру и реплике;

* проверять работоспособность репликации в кластере


---


### Задание


#### Создание кластера
1. Перейдите на главную страницу сервиса Managed Service for PostgreSQL.
   
   ![изображение](https://github.com/user-attachments/assets/9023dd2f-f5c6-4150-937a-b4620ab3d14b)

1. Создайте кластер PostgreSQL со следующими параметрами:
- класс хоста: s2.micro, диск network-ssd любого размера;

   ![изображение](https://github.com/user-attachments/assets/cd22bd94-2182-438a-a163-901c78df9ec6)

   ![изображение](https://github.com/user-attachments/assets/b7142cb8-5268-4ad6-8f86-c36336ad67e0)

- хосты: нужно создать два хоста в двух разных зонах доступности и указать необходимость публичного доступа, то есть публичного IP адреса, для них;

   ![изображение](https://github.com/user-attachments/assets/a08dc92b-6d05-4f31-99d8-adb2d884dc53)

- установите учётную запись для пользователя и базы.

  ![изображение](https://github.com/user-attachments/assets/d1b16262-5a18-4779-9aba-cc740aa22673)

Остальные параметры оставьте по умолчанию либо измените по своему усмотрению.

* Нажмите кнопку «Создать кластер» и дождитесь окончания процесса создания, статус кластера = RUNNING. Кластер создаётся от 5 до 10 минут.

  ![изображение](https://github.com/user-attachments/assets/b2418c0a-104a-4a52-bbf0-71e8a9594869)


#### Подключение к мастеру и реплике 

* Используйте инструкцию по подключению к кластеру, доступную на вкладке «Обзор»: cкачайте SSL-сертификат и подключитесь к кластеру с помощью утилиты psql, указав hostname всех узлов и атрибут ```target_session_attrs=read-write```.

  ![изображение](https://github.com/user-attachments/assets/4abee118-f415-4c31-b6ae-38181bbe735b)


* Проверьте, что подключение прошло к master-узлу.
```
select case when pg_is_in_recovery() then 'REPLICA' else 'MASTER' end;
```

   ![изображение](https://github.com/user-attachments/assets/5e7ea625-8547-44a2-8877-5e265fe6a5fd)


* Посмотрите количество подключенных реплик:
```
select count(*) from pg_stat_replication;
```

   ![изображение](https://github.com/user-attachments/assets/dae843f2-74e2-41cb-b46c-5662ca75f849)


### Проверьте работоспособность репликации в кластере

* Создайте таблицу и вставьте одну-две строки.
```
CREATE TABLE test_table(text varchar);
```
```
insert into test_table values('Строка 1');
```

   ![изображение](https://github.com/user-attachments/assets/87a7a2a5-a32a-4dc5-aeb6-2678b7aa53ae)

* Выйдите из psql командой ```\q```.

   ![изображение](https://github.com/user-attachments/assets/a9fa5674-08d7-4e4b-aba3-813bac77862c)

* Теперь подключитесь к узлу-реплике. Для этого из команды подключения удалите атрибут ```target_session_attrs```  и в параметре атрибут ```host``` передайте только имя хоста-реплики. Роли хостов можно посмотреть на соответствующей вкладке UI консоли.

   ![изображение](https://github.com/user-attachments/assets/9b31d112-c225-470e-98ea-7e3165400b4f)


* Проверьте, что подключение прошло к узлу-реплике.
```
select case when pg_is_in_recovery() then 'REPLICA' else 'MASTER' end;
```

![изображение](https://github.com/user-attachments/assets/8aa86ac9-5f88-4c92-80f9-ff9fdeabd19b)


* Проверьте состояние репликации
```
select status from pg_stat_wal_receiver;
```

![изображение](https://github.com/user-attachments/assets/c6bd9b27-8680-4472-b0fa-4a9e0c90a149)


* Для проверки, что механизм репликации данных работает между зонами доступности облака, выполните запрос к таблице, созданной на предыдущем шаге:
```
select * from test_table;
```

![изображение](https://github.com/user-attachments/assets/30b10ab8-5e96-4169-9314-c0ba629ac974)


*В качестве результата вашей работы пришлите скриншоты:*

*1) Созданной базы данных;*

![изображение](https://github.com/user-attachments/assets/277dd1a7-cf48-4970-98c1-89193ae194b0)


*2) Результата вывода команды на реплике ```select * from test_table;```.*

![изображение](https://github.com/user-attachments/assets/d89f3249-9eee-451d-bb30-6ce7335977a0)
