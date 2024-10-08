# Домашнее задание к занятию «`Кластеризация и балансировка нагрузки`» - `Арзыбов Владислав`

### Цель задания
В результате выполнения этого задания вы научитесь:
1. Настраивать балансировку с помощью HAProxy
2. Настраивать связку HAProxy + Nginx

------

### Чеклист готовности к домашнему заданию

1. Установлена операционная система Ubuntu на виртуальную машину и имеется доступ к терминалу
2. Просмотрены конфигурационные файлы, рассматриваемые на лекции, которые находятся по [ссылке](https://github.com/netology-code/sflt-homeworks/tree/main/2)


------



### Задание 1
- Запустите два simple python сервера на своей виртуальной машине на разных портах

  ![изображение](https://github.com/user-attachments/assets/78f972ba-72a7-4db7-87b4-4e5f23d2e54f)

- Установите и настройте HAProxy, воспользуйтесь материалами к лекции по [ссылке](https://github.com/netology-code/sflt-homeworks/tree/main/2)

  ![изображение](https://github.com/user-attachments/assets/0959de80-5ee2-4c07-95dc-a5aacb033e8b)

- Настройте балансировку Round-robin на 4 уровне.

  ![изображение](https://github.com/user-attachments/assets/be482f27-e017-4ca6-96d7-9d72fb841f30)
  
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

  [haproxy.cfg](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/haproxy_1.cfg)

  ![изображение](https://github.com/user-attachments/assets/dbf92815-6348-483e-8327-7bc171b5e2c7)
  ![изображение](https://github.com/user-attachments/assets/cedf4335-9f39-446a-a114-c79d13a53b06)




### Задание 2
- Запустите три simple python сервера на своей виртуальной машине на разных портах

  ![изображение](https://github.com/user-attachments/assets/5dee2d2b-73fc-4414-8583-6cacd604f150)

- Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4

  ![изображение](https://github.com/user-attachments/assets/1ad6a0f7-49be-46bf-a865-b67f1a028ab2)

- HAproxy должен балансировать только тот http-трафик, который адресован домену example.local

  ![изображение](https://github.com/user-attachments/assets/dd8db4b5-9261-47c0-9ab4-3b9d61358020)

- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

  [haproxy.cfg](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/haproxy.cfg_2)

  ![изображение](https://github.com/user-attachments/assets/393c8b77-010d-43d3-90ae-2f53d994e45a)

  ![изображение](https://github.com/user-attachments/assets/08baa0fe-6754-4960-a791-9e50c4179102)




---

## Задания со звёздочкой*
Эти задания дополнительные. Их можно не выполнять. На зачёт это не повлияет. Вы можете их выполнить, если хотите глубже разобраться в материале.

---

### Задание 3*
- Настройте связку HAProxy + Nginx как было показано на лекции.

  ![изображение](https://github.com/user-attachments/assets/b05652ee-d1e8-460a-bc99-91e28430c297)

- Настройте Nginx так, чтобы файлы .jpg выдавались самим Nginx (предварительно разместите несколько тестовых картинок в директории /var/www/), а остальные запросы переадресовывались на HAProxy, который в свою очередь переадресовывал их на два Simple Python server.
  
- На проверку направьте конфигурационные файлы nginx, HAProxy, скриншоты с запросами jpg картинок и других файлов на Simple Python Server, демонстрирующие корректную настройку.

  


---

### Задание 4*
- Запустите 4 simple python сервера на разных портах.
  
  ![изображение](https://github.com/user-attachments/assets/d8756535-b281-4504-94eb-c5b14eff4fb8)

- Первые два сервера будут выдавать страницу index.html вашего сайта example1.local (в файле index.html напишите example1.local)
- Вторые два сервера будут выдавать страницу index.html вашего сайта example2.local (в файле index.html напишите example2.local)

  ![изображение](https://github.com/user-attachments/assets/f0837f29-ad7f-4dd4-8fe9-91990ce82616)
  
- Настройте два бэкенда HAProxy

  ![изображение](https://github.com/user-attachments/assets/fc850399-ef8e-45c2-a6c2-11d4924c7a9a)

- Настройте фронтенд HAProxy так, чтобы в зависимости от запрашиваемого сайта example1.local или example2.local запросы перенаправлялись на разные бэкенды HAProxy

  ![изображение](https://github.com/user-attachments/assets/75e113a1-c56c-4662-be7b-923f99b6bc8e)

- На проверку направьте конфигурационный файл HAProxy, скриншоты, демонстрирующие запросы к разным фронтендам и ответам от разных бэкендов.

  [haproxy.cfg](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/10_Otkazoustojchivost/haproxy.cfg_4)

  ![изображение](https://github.com/user-attachments/assets/a8197f8b-1258-4103-8375-a208fc3ac20c)

  ![изображение](https://github.com/user-attachments/assets/a93c2ac9-3d79-4bc9-b915-a828df0782f6)




------

### Правила приема работы

1. Необходимо следовать инструкции по выполнению домашнего задания, используя для оформления репозиторий Github
2. В ответе необходимо прикладывать требуемые материалы - скриншоты, конфигурационные файлы, скрипты. Необходимые материалы для получения зачета указаны в каждом задании.


------

### Критерии оценки

- Зачет - выполнены все задания, ответы даны в развернутой форме, приложены требуемые скриншоты, конфигурационные файлы, скрипты. В выполненных заданиях нет противоречий и нарушения логики
- На доработку - задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки, приложены не все требуемые материалы.
