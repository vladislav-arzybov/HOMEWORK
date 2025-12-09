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

> По аналогии с ранее созданным secret.backend.tfvars для передачи access_key и secret_key через файл не содержащийся в репозитории, токены GitHub и Yandex Cloud передаются в Kubernetes в виде переменных окружения из фала ```.env``` и используются при создании Secret без хранения значений в коде. Пример содержимого:

```
export GITHUB_TOKEN=xxxxx
export AWS_ACCESS_KEY_ID=xxxxx
export AWS_SECRET_ACCESS_KEY=xxxxx
```

> Добавляем переменные окружения: source .env

> Создаем secrets и проверяем: kubectl get secrets -n atlantis

```
kubectl create secret generic atlantis-env \
  -n atlantis \
  --from-literal=AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  --from-literal=AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  --from-literal=GITHUB_TOKEN="$GITHUB_TOKEN"
```

<img width="642" height="59" alt="изображение" src="https://github.com/user-attachments/assets/42ccf279-692d-4c6d-9312-050ed13ce9aa" />

> Также можно проверить что переменные сохранились корректно через команды:
- echo $GITHUB_TOKEN
- echo $AWS_ACCESS_KEY_ID
- echo $AWS_SECRET_ACCESS_KEY



Удаление!
- kubectl delete -n atlantis secrets atlantis-github
- kubectl delete -n atlantis secrets yc-credentials
- kubectl delete -n atlantis secrets atlantis-env

Копирование!
- scp -r /home/reivol/Terraform2/05_diplom/atlantis reivol@46.21.246.134:/home/reivol/
- scp -r  reivol@46.21.246.134:/home/reivol/atlantis /home/reivol/Terraform2/05_diplom/atlantis/


#### Отладка

- kubectl get pods -n atlantis
- kubectl describe pod -n atlantis atlantis-666c5577c-rptpb
- kubectl logs -n atlantis atlantis-666c5577c-rptpb --previous

> Удаление
- kubectl -n atlantis delete deployments.apps atlantis 
- kubectl -n atlantis delete configmaps atlantis-config
- kubectl -n atlantis delete svc atlantis

> Установка
- kubectl apply -f atlantis-cm.yaml
- kubectl apply -f atlantis-deployment.yaml
- kubectl apply -f atlantis-svc.yaml
