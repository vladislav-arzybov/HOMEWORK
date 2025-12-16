### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.

> Для выполнения данного блока воспользуюсь GitHub Actions, т.к. раньше не использовал его в работе как и Atlantis.

> Для начала создадим новый токен в DockerHub, в дальнейшем его значения будут использоваться в секрете DOCKERHUB_TOKEN:
- DockerHub - Account Settings - Personal access tokens - Generate new token

<img width="1600" height="254" alt="изображение" src="https://github.com/user-attachments/assets/f88d1795-c087-425f-8c62-5f763f115085" />

> Для выполнения второго задания, автоматического деплоя нового docker образа, необходимо заранее получить KUBE_CONFIG:
- cat ~/.kube/config | base64 -w0

> Полученную информацию необходимо добавить в репозиторий GitHub [my_nginx_test_app_diplom](https://github.com/vladislav-arzybov/my_nginx_test_app_diplom) в виде Secrets, это нужно для доступа к DockerHub и кластеру:
- Settings - Secrets and variables - Actions - New repository secret

```
DOCKERHUB_USERNAME
arzybov

DOCKERHUB_TOKEN
dckr_xxxxxxxx

KUBE_CONFIG
YXBpxxxxxxxxx
```

<img width="791" height="264" alt="изображение" src="https://github.com/user-attachments/assets/ccd8dc5f-bfda-4cac-bccd-12a19a615d2a" />

> Создадим необходиму структуру каталогов в ранее созданном репозитории [my_nginx_test_app_diplom](https://github.com/vladislav-arzybov/my_nginx_test_app_diplom)
- mkdir -p .github/workflows

---

2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.

> Создадим workflow build-push.yaml:
- nano .github/workflows/build-push.yaml

[build-push.yaml]()

```
name: Build and Push

on:
  push:
    branches:
      - "**"

jobs:
  docker-build:
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: arzybov/test-app-nginx:1.0.${{ github.run_number }}
```

> Пушим в git
- git add .
- git commit -m 'build-push'
- git push origin main

<img width="796" height="271" alt="изображение" src="https://github.com/user-attachments/assets/54909fa3-a2d8-4701-a620-8f75b52132b0" />

<img width="1304" height="239" alt="изображение" src="https://github.com/user-attachments/assets/41f69923-f27f-4594-a701-42459dd9e4af" />

> Проверяем наличие образа в [DockerHub](https://hub.docker.com/repository/docker/arzybov/test-app-nginx/tags)

<img width="1575" height="310" alt="изображение" src="https://github.com/user-attachments/assets/a32b85d1-981a-4d2a-96fd-d6ebd781bf76" />

---

3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

> Создадим workflow build-push-deploy.yaml:

[build-push-deploy.yaml]()

```
name: build and deploy

on:
  push:
    tags:
      - "v*.*.*"

jobs:
  docker-deploy:
    runs-on: ubuntu-22.04

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Extract tag
        run: echo "IMAGE_TAG=${GITHUB_REF_NAME}" >> $GITHUB_ENV

      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: arzybov/test-app-nginx:${{ env.IMAGE_TAG }}

      - name: Install kubectl
        uses: azure/setup-kubectl@v4
        with:
          version: v1.29.0

      - name: Configure kubeconfig
        run: |
          mkdir -p ~/.kube
          echo "${{ secrets.KUBE_CONFIG }}" | base64 -d > ~/.kube/config

      - name: Deploy to Kubernetes
        run: |
          kubectl -n app set image deployment/test-app-deployment \
            nginx-docker=arzybov/test-app-nginx:${{ env.IMAGE_TAG }}
```

> Заранее вносим правки в index.html, чтобы визуально увидеть изменения страницы.

```
<html>
<head>
DevOps-Netology-diplom
</head>
<body>
<h1>Hello! Welcome to my test app page. (v4.0.0)</h1>
</body>
</html>
```

> Пушим в git
- git add .
- git commit -m 'build-push-deploy-4'
- git push origin main

<img width="892" height="291" alt="изображение" src="https://github.com/user-attachments/assets/56275d2b-20f3-4b71-9bb7-10fb934cb471" />

> Добавляем тэг, v4.0.0, пушим в git
- git tag v4.0.0
- git push origin v4.0.0

<img width="666" height="93" alt="изображение" src="https://github.com/user-attachments/assets/3e1f8745-593e-492d-af6e-6a5a3820bc9f" />

> Проверяем сборку

<img width="1656" height="402" alt="изображение" src="https://github.com/user-attachments/assets/60d255b1-9b01-47b8-8472-4cc1f9b84c8b" />

> Образ создан

<img width="1590" height="326" alt="изображение" src="https://github.com/user-attachments/assets/29e6d237-694c-4da9-b2ff-1dbbeb4d8d16" />

> Деплой выполнен автоматически
- kubectl get all -n app -o wide

<img width="1563" height="274" alt="изображение" src="https://github.com/user-attachments/assets/e370b111-7ec1-4e6e-a9ab-e7da9f0c36b8" />

> Изменения на странице актуальны

<img width="788" height="167" alt="изображение" src="https://github.com/user-attachments/assets/98eba521-2991-408d-85a9-1a5b60ed4f14" />
