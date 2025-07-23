# Домашнее задание к занятию «Обновление приложений» - `Арзыбов Владислав`

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment).
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/).

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

### Решение:

Учитывая небольшой запас по ресурсам, а также то что новые версии приложений не умеют работать со старыми, оптимальной стратегией в данном случае будет - Recreate.
Старые поды будут предварительно удалены, следовательно больше не будут потреблять ресурсы системы и не смогут конфликтовать с запущенной новой версией приложения.

### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.

[deployment.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/14_Updating_applications/deployment.yaml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-multitool-deployment
  annotations:
    kubernetes.io/change-cause: "Update to 1.19"
  namespace: default
  labels:
    app: nginx-multitool
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
  replicas: 5
  selector:
    matchLabels:
      app: nginx-multitool
  template:
    metadata:
      labels:
        app: nginx-multitool
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
      - name: multitool
        image: wbitt/network-multitool:latest
        env:
        - name: HTTP_PORT
          valueFrom:
            configMapKeyRef:
              name: env-config
              key: HTTP_PORT
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-config
data:
  HTTP_PORT: "8080"
```

<img width="741" height="128" alt="изображение" src="https://github.com/user-attachments/assets/910cc637-ec49-4dd6-9af3-402c9b722362" />

<img width="1566" height="58" alt="изображение" src="https://github.com/user-attachments/assets/95a6d00f-8e0d-4cb7-9fc3-15e2f83e8bde" />

<img width="1688" height="55" alt="изображение" src="https://github.com/user-attachments/assets/a1fbfb62-48f8-4431-9fdb-0144accbf809" />

2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.

<img width="825" height="167" alt="изображение" src="https://github.com/user-attachments/assets/d36a01d3-90bd-4e53-b81d-93d92c40d764" />

<img width="847" height="184" alt="изображение" src="https://github.com/user-attachments/assets/060541d0-6ea5-448d-9736-3220c0b4c30f" />

<img width="823" height="152" alt="изображение" src="https://github.com/user-attachments/assets/999c4a1e-e774-41dc-8d0f-40cd36d2a590" />

<img width="732" height="131" alt="изображение" src="https://github.com/user-attachments/assets/6d308c71-355b-4764-aa98-f4a51068d926" />

<img width="1695" height="223" alt="изображение" src="https://github.com/user-attachments/assets/fc6e8d44-df80-4f50-a29c-2b1be64c7aba" />

3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.

<img width="1667" height="534" alt="изображение" src="https://github.com/user-attachments/assets/3a732a10-2ea8-49ab-98c0-960f9a49ebbb" />

4. Откатиться после неудачного обновления.
- kubectl rollout undo deployment nginx-multitool-deployment --to-revision=2

<img width="905" height="451" alt="изображение" src="https://github.com/user-attachments/assets/8313fe5d-29e4-4083-9c44-54e3d503a77e" />

- kubectl rollout history deployment
- kubectl get rs -o wide
- kubectl get deployments.apps -o wide --show-labels

<img width="1688" height="273" alt="изображение" src="https://github.com/user-attachments/assets/7d9c7e88-20d2-40d3-95c7-fa5ac07142bf" />



## Дополнительные задания — со звёздочкой*

Задания дополнительные, необязательные к выполнению, они не повлияют на получение зачёта по домашнему заданию. **Но мы настоятельно рекомендуем вам выполнять все задания со звёздочкой.** Это поможет лучше разобраться в материале.   

### Задание 3*. Создать Canary deployment

1. Создать два deployment'а приложения nginx.

[ng-deployment-prod.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/14_Updating_applications/ng-deployment-prod.yaml)

[ng-deployment-test.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/14_Updating_applications/ng-deployment-test.yaml)

2. При помощи разных ConfigMap сделать две версии приложения — веб-страницы.

```
data:
  index.html: |
    <html>
    <body>
      <h1>Welcome to nginx prod v1.27</h1>
    </body>
    </html>
```

```
data:
  index.html: |
    <html>
    <body>
      <h1>Welcome to nginx test v1.28</h1>
    </body>
    </html>
```

3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

[ingress-prod.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/14_Updating_applications/ingress-prod.yaml)

[ingress-canary.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/14_Updating_applications/ingress-canary.yaml)

```
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
```

#### Проверяем:

<img width="1573" height="310" alt="изображение" src="https://github.com/user-attachments/assets/6da66e5e-7be8-4584-8b94-4354e4ac4b17" />

<img width="818" height="75" alt="изображение" src="https://github.com/user-attachments/assets/f2be58b2-b4e7-43e3-a69f-dcd81dc4d228" />

<img width="396" height="432" alt="изображение" src="https://github.com/user-attachments/assets/159c75dd-1701-4b93-a6b2-f1d1a29ad63d" />



### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
