### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.

> Создаем новый репозиторий ```my_nginx_test_app_diplom``` на https://github.com

<img width="762" height="122" alt="изображение" src="https://github.com/user-attachments/assets/7a01a71a-44d7-4808-8f92-adaf67f1163c" />

> Копируем созданный репозиторий в локальный каталог

<img width="1023" height="112" alt="изображение" src="https://github.com/user-attachments/assets/40c22f87-3276-4ef8-848d-43bacca10508" />

   б. Подготовьте Dockerfile для создания образа приложения.

> Подготовим index.html страницу для nginx:

```
<html>
<head>
DevOps-Netology-diplom
</head>
<body>
<h1>Hello! Welcome to my test app page.</h1>
</body>
</html>
```

> Создаем Dockerfile

```
# Последний стабильный образ с nginx
FROM nginx:1.27.2

# Копируем ранее созданный шаблон index.html заменяя стандартную страницу nginx
COPY index.html /usr/share/nginx/html

# Порт который будет слушать контейнер
EXPOSE 80
```

> Собираем образ: ```docker build -t arzybov/test-app-nginx:1.0.0 .```

<img width="1006" height="468" alt="изображение" src="https://github.com/user-attachments/assets/092142c7-8360-4c6b-a9a7-2e04944b5f45" />

> Проверяем создание образа ```docker images```

<img width="1082" height="56" alt="изображение" src="https://github.com/user-attachments/assets/10eae2ab-344e-43b8-96cc-9a17722541f8" />

> Проверяем работоспособность контейнера: ```docker run -d -p 8080:80 arzybov/test-app-nginx:1.0.0```

<img width="1461" height="93" alt="изображение" src="https://github.com/user-attachments/assets/d3f5e72a-4309-4bac-a05b-ba18352647c8" />

> Выполняем curl на порт 8080, успех.

<img width="768" height="165" alt="изображение" src="https://github.com/user-attachments/assets/3d025f6d-ae34-4882-89cd-64dee7d49d14" />
   
3. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.
