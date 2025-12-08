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

- kubectl create namespace atlantis

```
kubectl create secret generic atlantis-github \
  -n atlantis \
  --from-literal=token=GITHUB_TOKEN
```

- yc iam create-token

- kubectl get secrets -ALL
- kubectl delete -n atlantis secrets atlantis-github
- kubectl delete -n atlantis secrets yc-credentials

```
.env
GITHUB_TOKEN=ghp_xxxxx
YC_TOKEN=t1.xxxxx
```

```
set -a
source .env
set +a
```

```
kubectl create secret generic atlantis-github \
  -n atlantis \
  --from-literal=token="$GITHUB_TOKEN"
```
