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

> Для начала создадим новый токен в DockerHub ```github-actions```:
- DockerHub - Account Settings - Personal access tokens - Generate new token

<img width="1600" height="254" alt="изображение" src="https://github.com/user-attachments/assets/f88d1795-c087-425f-8c62-5f763f115085" />

> Cоздадим в репозитории GitHub Secrets для доступа к DockerHub
- Settings - Secrets and variables - Actions - New repository secret

```
DOCKERHUB_USERNAME
arzybov

DOCKERHUB_TOKEN
dckr_xxxxxxxx
```

<img width="791" height="204" alt="изображение" src="https://github.com/user-attachments/assets/52533df4-37e5-4f74-b787-a15dba971fae" />

> Создадим необходиму структуру каталогов в ранее созданном репозитории [my_nginx_test_app_diplom](https://github.com/vladislav-arzybov/my_nginx_test_app_diplom)
- mkdir -p .github/workflows

> Для выполнения задания потребуются 2 workflow:

2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.

> Создадим workflow build-push.yaml:

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
          tags: |
            arzybov/test-app-nginx:latest
            arzybov/test-app-nginx:1.0.${{ github.run_number }}
```
