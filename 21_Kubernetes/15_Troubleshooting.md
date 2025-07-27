# Домашнее задание к занятию Troubleshooting - `Арзыбов Владислав`

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```

<img width="1533" height="75" alt="изображение" src="https://github.com/user-attachments/assets/26faf03c-bad6-4b05-9259-6578fd6f0a14" />

Приложения создаются в разных namespaces которые предварительно отсутствуют в кластере.

<img width="422" height="72" alt="изображение" src="https://github.com/user-attachments/assets/955e4a59-99fc-46f3-af45-2af564198fcb" />

<img width="1140" height="74" alt="изображение" src="https://github.com/user-attachments/assets/669eb5f3-cd9c-419e-895c-08914e1fee9e" />

2. Выявить проблему и описать.

Проверяем что поды запущены и с ними всё хорошо

<img width="615" height="128" alt="изображение" src="https://github.com/user-attachments/assets/480e6039-ad50-4c4f-838a-5c0808574f44" />

Проверяем привязку сервиса

<img width="757" height="60" alt="изображение" src="https://github.com/user-attachments/assets/7ba2d3c6-8f2c-48a6-b743-2407e73e0126" />

Проверяем доступность приложения по имени сервиса auth-db из контейнера приложения auth-db

<img width="726" height="486" alt="изображение" src="https://github.com/user-attachments/assets/bf3dfec7-c703-4d31-8422-769ae76d6f78" />

Проверяем логи приложения web-consumer, видим ошибку подключения к сервису auth-db по имени

<img width="625" height="73" alt="изображение" src="https://github.com/user-attachments/assets/92ee380d-3e88-4f3e-bc11-86508b4026bc" />

3. Исправить проблему, описать, что сделано.

Подключаемся к контейнеру одного из экземпляров приложения web-consumer, проверяем доступность сервиса auth-db по имени и ip адресу

<img width="986" height="556" alt="изображение" src="https://github.com/user-attachments/assets/49b73227-610c-4d7e-8f44-05dd2309b487" />

Повторно проверяем доступность сервиса auth-db дополнительно указав полное dns имя с учетом другого namespace ```data```, подключение работает.
- curl auth-db.data.svc.cluster.local

<img width="734" height="468" alt="изображение" src="https://github.com/user-attachments/assets/039983ed-83d1-44e3-959f-e2d63a70c9fa" />

Проблема возникает т.к приложения находятся в разных namespaces, поэтому недостаточно указать лишь имя сервиса для подключения к приложению auth-db.

4. Продемонстрировать, что проблема решена.

Необходимо заменить команду ```do curl auth-db``` на ```do curl auth-db.data.svc.cluster.local```, проверяем, ошибки подключения в логах отсутствуют
- kubectl edit deployments.apps web-consumer -n web

<img width="867" height="556" alt="изображение" src="https://github.com/user-attachments/assets/c64af436-52ed-4ffe-b529-86b688b75609" />


<details>
  <summary>task.yaml</summary>

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-consumer
  namespace: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-consumer
  template:
    metadata:
      labels:
        app: web-consumer
    spec:
      containers:
      - command:
        - sh
        - -c
        - while true; do curl auth-db.data.svc.cluster.local; sleep 5; done
        image: radial/busyboxplus:curl
        name: busybox
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-db
  namespace: data
spec:
  replicas: 1
  selector:
    matchLabels:
      app: auth-db
  template:
    metadata:
      labels:
        app: auth-db
    spec:
      containers:
      - image: nginx:1.19.1
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: auth-db
  namespace: data
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: auth-db
```

</details>




### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
