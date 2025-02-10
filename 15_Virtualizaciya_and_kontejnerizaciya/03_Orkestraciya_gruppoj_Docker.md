# «Оркестрация группой Docker контейнеров на примере Docker Compose» - `Арзыбов Владислав`

## Задача 1

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.

![изображение](https://github.com/user-attachments/assets/809f801c-b4a0-4e5d-b1ed-c76ff7c0f9dc)

- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: ```{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}```
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);

![изображение](https://github.com/user-attachments/assets/71b4676b-b154-48d6-bb35-3e64570431e4)

- скачайте образ nginx:1.21.1;

![изображение](https://github.com/user-attachments/assets/92fca729-7283-4717-845d-eac4cd23e075)

- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```

![изображение](https://github.com/user-attachments/assets/0dc789de-214b-4403-bf10-367e13e85c2c)

- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП).

![изображение](https://github.com/user-attachments/assets/96101c69-0b10-447a-a945-a40c59da12e7)

![изображение](https://github.com/user-attachments/assets/58d55567-867c-4aa4-8a9d-2f1785c1cc2b)

- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

https://hub.docker.com/repository/docker/arzybov/custom-nginx/general

![изображение](https://github.com/user-attachments/assets/eb520e51-3932-408a-9adf-378745731def)


## Задача 2
1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:
- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080

![изображение](https://github.com/user-attachments/assets/fa45944a-9c35-4656-a4ed-35f5038d295d)

![изображение](https://github.com/user-attachments/assets/6567ae63-8466-446e-a935-7f3657ce091f)

2. Не удаляя, переименуйте контейнер в "custom-nginx-t2"

![изображение](https://github.com/user-attachments/assets/f9c5db63-814e-4ee4-8011-eef7276b5efe)
  
3. Выполните команду ```date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html```

![изображение](https://github.com/user-attachments/assets/6886db11-3f8a-41db-a6bf-110694713d7f)

4. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.

![изображение](https://github.com/user-attachments/assets/24ebfbc9-ef16-4d75-b3f5-63ec76acea33)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.


## Задача 3
1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".

![изображение](https://github.com/user-attachments/assets/92f54207-2d26-422f-8433-ed2bec5c1213)
  
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.

![изображение](https://github.com/user-attachments/assets/13aaca97-0b3a-4f0c-9ff5-9e1a2bbc37d7)

3. Выполните ```docker ps -a``` и объясните своими словами почему контейнер остановился.

![изображение](https://github.com/user-attachments/assets/5a2b2827-18d6-40e4-9d11-0e27964fd5c8)

- Нажатие Ctrl+C при присоединении к контейнеру Docker отправляет в него сигнал SIGKILL и останавливает контейнер

4. Перезапустите контейнер

![изображение](https://github.com/user-attachments/assets/73400c42-569e-4eda-8b00-d180255fe3b5)

5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.

![изображение](https://github.com/user-attachments/assets/8a4a6a49-41eb-440e-844a-9ed27b8cac32)

6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
- apt-get update
- apt-get install nano

7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".

![изображение](https://github.com/user-attachments/assets/0ea91761-f09b-47cf-b1f3-a423106d9cf9)

8. Запомните(!) и выполните команду ```nginx -s reload```, а затем внутри контейнера ```curl http://127.0.0.1:80 ; curl http://127.0.0.1:81```.

![изображение](https://github.com/user-attachments/assets/0b518e76-e901-45f2-b500-b8681f9c772f)

9. Выйдите из контейнера, набрав в консоли  ```exit``` или Ctrl-D.

![изображение](https://github.com/user-attachments/assets/1419fa8e-93aa-4b56-b160-d6e7c6e4bcdb)

10. Проверьте вывод команд: ```ss -tlpn | grep 127.0.0.1:8080``` , ```docker port custom-nginx-t2```, ```curl http://127.0.0.1:8080```. Кратко объясните суть возникшей проблемы.

![изображение](https://github.com/user-attachments/assets/7f960205-951b-44f2-b3e4-928bc4403b34)

- При запуске контейнера было выполнено сопоставление 80 порта внутри контейнера с портом 8080 на хост-машине, в данный момент nginx внутри контейнера работает на 81 порту.

11. * Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)

12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

![изображение](https://github.com/user-attachments/assets/ebe8dd53-de26-4257-86cb-c0647c982048)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

## Задача 4


- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку  текущий рабочий каталог ```$(pwd)``` на хостовой машине в ```/data``` контейнера, используя ключ -v.

docker run -t -d --name centos -v $(pwd):/data centos

![изображение](https://github.com/user-attachments/assets/2cfc6dca-7933-4847-964f-d2b17c6e4204)

- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив текущий рабочий каталог ```$(pwd)``` в ```/data``` контейнера.

docker run -t -d --name debian -v $(pwd):/data debian

![изображение](https://github.com/user-attachments/assets/ad023162-54a0-486e-b1a2-08e26b942aa2)

- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.

![изображение](https://github.com/user-attachments/assets/b4593ab4-b0dc-400b-92ba-09c337b8f3b1)

- Добавьте ещё один файл в текущий каталог ```$(pwd)``` на хостовой машине.

![изображение](https://github.com/user-attachments/assets/e31c5552-a059-42e9-969b-877b6c94c82f)

- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

![изображение](https://github.com/user-attachments/assets/48a3dc42-d962-4282-9705-3d3ed9d06afe)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.


## Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.

![изображение](https://github.com/user-attachments/assets/c2aab51a-1448-4eb8-abbe-0db10613c059)

"compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

![изображение](https://github.com/user-attachments/assets/337db934-6c7d-4c7d-8c13-85bb1f81b7da)


И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )

![изображение](https://github.com/user-attachments/assets/14c01478-aeba-4bbd-8576-b84c8e35354a)

- Если в каталоге присутствуют yml файлы названия которых compose и docker-compose, то предпочтение отдается compose.yaml, т.к. этот шаблон является предпочтительным.

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

```bash
include:
  - docker-compose.yaml 
```

![изображение](https://github.com/user-attachments/assets/36ec53cf-58da-41e6-a36f-6a8f90537304)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/

![изображение](https://github.com/user-attachments/assets/2ad8e558-3bf7-4c00-9000-c3710c18e606)

5. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)

![изображение](https://github.com/user-attachments/assets/2b272e7c-3e7c-4fb4-9619-714d7d5bad75)

7. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```

![изображение](https://github.com/user-attachments/assets/65ccf863-d96e-4f3e-8700-6ab84c8a3a25)

![изображение](https://github.com/user-attachments/assets/1b24fdeb-69c8-4362-a4e5-4025283a0bcc)

![изображение](https://github.com/user-attachments/assets/bee2f8b1-5a46-4e07-93ec-2dd562dcf94d)

6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

![изображение](https://github.com/user-attachments/assets/ea29e1c7-1681-494f-92e9-70e003a52f07)

![изображение](https://github.com/user-attachments/assets/d9f92240-b4a6-4436-89fb-fb910c791f47)


7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

---

### Правила приема

Домашнее задание выполните в файле readme.md в GitHub-репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.
