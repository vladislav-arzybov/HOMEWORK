# Домашнее задание к занятию 5. «Практическое применение Docker» - `Арзыбов Владислав`

### Инструкция к выполнению

1. Для выполнения заданий обязательно ознакомьтесь с [инструкцией](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD) по экономии облачных ресурсов. Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
2. **Своё решение к задачам оформите в вашем GitHub репозитории.**
3. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.
4. Сопроводите ответ необходимыми скриншотами.

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0
1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```

![изображение](https://github.com/user-attachments/assets/7d3e7ec5-3b72-44fd-b4af-93271ed0ddf2)

```
Command 'docker-compose' not found, but can be installed with:

sudo snap install docker          # version 24.0.5, or
sudo apt  install docker-compose  # version 1.25.0-1

See 'snap info docker' for additional versions.
```
В случае наличия установленного в системе ```docker-compose``` - удалите его.  
2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  

![изображение](https://github.com/user-attachments/assets/bb3a5cea-769d-49cc-b63a-628f97fe2aa2)


###  **Своё решение к задачам оформите в вашем GitHub репозитории!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**

---

## Задача 1
1. Сделайте в своем github пространстве fork [репозитория](https://github.com/netology-code/shvirtd-example-python/blob/main/README.md).
   Примечание: В связи с доработкой кода python приложения. Если вы уверены что задание выполнено вами верно, а код python приложения работает с ошибкой то используйте вместо main.py файл not_tested_main.py(просто измените CMD)
2. Создайте файл с именем ```Dockerfile.python``` для сборки данного проекта(для 3 задания изучите https://docs.docker.com/compose/compose-file/build/ ). Используйте базовый образ ```python:3.9-slim```. 
Обязательно используйте конструкцию ```COPY . .``` в Dockerfile. Не забудьте исключить ненужные в имадже файлы с помощью dockerignore. Протестируйте корректность сборки.

![изображение](https://github.com/user-attachments/assets/ac45c74e-10b4-4284-b180-7c2392cfbc5f)
 
3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).
4. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.
---
### ВНИМАНИЕ!
!!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```.dockerignore```,```bash-скрипт```. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!
---

## Задача 2 (*)
1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

![изображение](https://github.com/user-attachments/assets/b897e693-2e6b-4bf6-b888-72079d258f61)


## Задача 3
1. Изучите файл "proxy.yaml"
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!

![изображение](https://github.com/user-attachments/assets/5f3569e8-b692-4f01-b22a-934c058492e8)

4. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете ```NULL``` --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.

![изображение](https://github.com/user-attachments/assets/35ff5d75-fce5-417d-9262-ddd2f2d0f2ef)

![изображение](https://github.com/user-attachments/assets/63579bb7-75d0-49b8-92d2-08d435a83a82)

5. Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.

![изображение](https://github.com/user-attachments/assets/08a9b75f-e17c-4621-837c-7709c5bd5e91)

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.

![изображение](https://github.com/user-attachments/assets/58480bbf-0561-48ee-a63d-3b3dae735eb1)


## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).

![изображение](https://github.com/user-attachments/assets/6367164d-8ce9-45dd-ad3d-ab2034fe734d)

2. Подключитесь к Вм по ssh и установите docker.

![изображение](https://github.com/user-attachments/assets/bca99e6e-6a02-44fa-835a-f12c14a67571)

3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.

![изображение](https://github.com/user-attachments/assets/1e000a97-f97d-4177-b2ec-044daf8f83c4)

![изображение](https://github.com/user-attachments/assets/854c8935-3c44-40aa-9b69-714b81e000a6)

4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. ПРИМЕЧАНИЕ:  приложение main.py( в отличие от not_tested_main.py) весьма вероятно упадет под нагрузкой, но успеет обработать часть запросов - этого достаточно. Обновленная версия (main.py) не прошла достаточного тестирования временем, но должна справиться с нагрузкой.

![изображение](https://github.com/user-attachments/assets/81306e74-0c8d-4b23-9073-291d9f50a95a)

5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```

На хосте добавляем пользователя в грппу docker: "sudo usermod -aG docker $USER", запускаем тестовый контейнер из образа

![изображение](https://github.com/user-attachments/assets/b7564413-6802-46b0-aadb-4fe08fc7b0df)

Настраиваем подключение на клиенте и проверяем наличие образов и контейнеров

![изображение](https://github.com/user-attachments/assets/9041604d-be3f-4912-bb88-8fc929d93ede)

Дополнительно скачиваем ещё один образ через клиент на удаленный хост

![изображение](https://github.com/user-attachments/assets/30fccc80-c03b-469f-9bf0-046162faf534)

Проверяем на хосте

![изображение](https://github.com/user-attachments/assets/f3cbf533-aebf-41de-b59b-43ba05d85c99)

6. В качестве ответа повторите  sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

[script.sh](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/15_Virtualizaciya_and_kontejnerizaciya/script.sh)

[fork-репозитория](https://github.com/vladislav-arzybov/shvirtd-example-python.git)

## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

Скачиваем образ и запускаем dive

![изображение](https://github.com/user-attachments/assets/34aa8021-4f74-4c4a-8dab-de14fad44029)

#### docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest hashicorp/terraform:latest

Находим идентификатор слоя с необходимым нам файлом

![изображение](https://github.com/user-attachments/assets/6dbeb686-aa5f-4e76-a1d7-3c29e7d4a23f)

#### sha256:da25c3c268493bc8d1313c7698a81a97a99c917ae09a248795e969d82cb53f65

Сохраняем образ в архив и распаковываем его в каталоге /tmp
```
docker image save -o /tmp/image.tar.gz hashicorp/terraform:latest
cd /tmp/ 
tar xf /tmp/image.tar.gz
```
![изображение](https://github.com/user-attachments/assets/b4e5faea-88d3-41d1-aea9-20f26af5f281)

Переходим в каталог blobs/sha256/ где находятся все слои

![изображение](https://github.com/user-attachments/assets/df67e82c-884f-4e50-b929-170438bf0e05)

Указываем идентификатор необходимого нам слоя и распаковываем его: tar xf da25c3c268493bc8d1313c7698a81a97a99c917ae09a248795e969d82cb53f65

Переходим в распакованный каталог bin где содержится необходимый нам файл terraform

![изображение](https://github.com/user-attachments/assets/f8f9aced-6d16-44c3-af49-6be6e4dd2e5c)

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

Заранее создадим каталог /tmp/ter/ и перейдем в него

![изображение](https://github.com/user-attachments/assets/3d84de73-a06a-470e-9114-108bc50cf15c)

Запускаем контейнер и копируем файл terraform в заранее подготовленный каталог: docker cp terraform:/bin/terraform ./

![изображение](https://github.com/user-attachments/assets/c81bd41a-433a-4e36-b859-facc8371cb4b)



## Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий .
