### Деплой инфраструктуры в terraform pipeline

1. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
5. Atlantis или terraform cloud или ci/cd-terraform



# Решение

https://www.youtube.com/watch?v=sV9IBczE3IA

> Создаем отдельный namespace для atlantis
- kubectl create namespace atlantis

> Получаем GITHUB_TOKEN: Profile → Settings → Developer settings → Personal access tokens
> Получаем YC_TOKEN: yc iam create-token

> По аналогии с ранее созданным secret.backend.tfvars для передачи access_key и secret_key через файл не содержащийся в репозитории, токены GitHub и Yandex Cloud передаются в Kubernetes в виде переменных окружения из фала ```.env``` и используются при создании Secret без хранения значений в коде. Пример содержимого:

```
GITHUB_TOKEN=ghp_xxxxx
YC_TOKEN=t1.xxxxx
```

> Добавляем переменные окружения

```
set -a
source .env
set +a
```

> Создаем secrets и проверяем: kubectl get secrets -n atlantis

```
kubectl create secret generic atlantis-github \
  -n atlantis \
  --from-literal=token="$GITHUB_TOKEN"
```

```
kubectl create secret generic yc-credentials \
  -n atlantis \
  --from-literal=YC_TOKEN="$YC_TOKEN"
```

<img width="657" height="76" alt="изображение" src="https://github.com/user-attachments/assets/b4c79909-01b3-4a93-bab1-1ae1ad4d5d8e" />

> Также можно проверить что переменные сохранились корректно через команды:
- echo $GITHUB_TOKEN
- echo $YC_TOKEN

Альтернативный вариант: source .env

```
.env
export GITHUB_TOKEN=ghp_xxxxx
export YC_TOKEN=t1.xxxxx
```

- kubectl delete -n atlantis secrets atlantis-github
- kubectl delete -n atlantis secrets yc-credentials



