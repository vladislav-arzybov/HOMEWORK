### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

---

https://www.youtube.com/watch?v=zn5T7FkpaTA

https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax

https://github.com/marketplace/actions/setup-node-js-environment

Self-hosted runners - собирать у себя


#### РЕШЕНИЕ

> Для выполнения данного блока воспользуюсь GitHub Actions, т.к. раньше не использовал его в работе как и Atlantis.

> Для начала создадим новый токен в DockerHub, в дальнейшем его значения будут использоваться в секрете DOCKERHUB_TOKEN:
- DockerHub - Account Settings - Personal access tokens - Generate new token

<img width="1600" height="254" alt="изображение" src="https://github.com/user-attachments/assets/f88d1795-c087-425f-8c62-5f763f115085" />

> Для выполнения второго задания, автоматического деплоя нового docker образа, необходимо получить заранее получить KUBE_CONFIG:
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

> Для выполнения задания потребуются 2 workflow:

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
