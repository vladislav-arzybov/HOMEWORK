# Домашнее задание к занятию «Запуск приложений в K8S» - `Арзыбов Владислав`

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.

#### kubectl apply -f deployment.yml

![изображение](https://github.com/user-attachments/assets/c49c8eb6-3af2-47fe-8ecd-245adce99a74)

Смотрим какой из контейнеров не запустился:

#### kubectl describe pod nginx-multitool

![изображение](https://github.com/user-attachments/assets/8fca7171-4552-4bb7-ac6a-5d97769334a5)

Проверяем логи:

- #### kubectl logs nginx-multitool-856cbbffc4-x5xd5 --all-containers=true
- #### kubectl logs deployments/nginx-multitool multitool

![изображение](https://github.com/user-attachments/assets/acf139f3-7554-49db-a257-e7faa330ad24)

Через переменные окружения изменим http порт для контейнера с multitool

[deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/03_Launching_applications_in_K8S/deployment.yml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-multitool
spec:
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
        image: nginx:latest
      - name: multitool
        image: wbitt/network-multitool:latest
        env:
        - name: HTTP_PORT
          value: '1180'
```

![изображение](https://github.com/user-attachments/assets/fa6177c1-a1cb-4048-a14f-ccf1d7f9370d)

2. После запуска увеличить количество реплик работающего приложения до 2.

```
spec:
  replicas: 2
```

3. Продемонстрировать количество подов до и после масштабирования.

![изображение](https://github.com/user-attachments/assets/ad6d5c0d-7c3b-4970-9547-2e3bf22b2e3b)

4. Создать Service, который обеспечит доступ до реплик приложений из п.1.

[nginx-svc.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/03_Launching_applications_in_K8S/nginx-svc.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
spec:
  selector:
    app: nginx-multitool
  ports:
    - name: nginx-port
      protocol: TCP
      port: 80
      targetPort: 80
    - name: multitool-https-port
      protocol: TCP
      port: 443
      targetPort: 443
    - name: multitool-http-port
      protocol: TCP
      port: 1180
      targetPort: 1180
```

#### kubectl get svc -o wide

![изображение](https://github.com/user-attachments/assets/e0e37808-4657-4055-ac5b-88c852c8b0eb)


5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

[multitool-pod.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/03_Launching_applications_in_K8S/multitool-pod.yml)

```
apiVersion: v1
kind: Pod
metadata:
  name: multitool
  labels:
    app: multitool
spec:
  containers:
    - name: multitool-pod
      image: wbitt/network-multitool:latest
```

![изображение](https://github.com/user-attachments/assets/6b516850-7bc2-4edc-8aac-f37005211fbe)

#### kubectl exec multitool -it -- /bin/sh

![изображение](https://github.com/user-attachments/assets/beac84d7-dac9-42bd-b6d5-e6610c76d61d)

![изображение](https://github.com/user-attachments/assets/030c2ff1-8b69-46bb-8279-e0e4aa1f96da)

![изображение](https://github.com/user-attachments/assets/06300600-a3d9-45bf-ba9b-39a253c9a3dd)

Аналогично если обращаться напрямую к pod по ip

![изображение](https://github.com/user-attachments/assets/2b921448-6227-43ac-ba45-7195a39579ba)


------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.

[nginx-deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/03_Launching_applications_in_K8S/nginx-deployment.yml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-init
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
      initContainers:
      - name: delay
        image: busybox
        command: ['sh', '-c', 'until nslookup nginx-init-svc.default.svc.cluster.local; do echo waiting for nginx-init-svc; sleep 5; done;']
```

2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.

![изображение](https://github.com/user-attachments/assets/73ea558d-72af-4789-a168-176fdcba077b)

3. Создать и запустить Service. Убедиться, что Init запустился.

[nginx-init-svc.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/03_Launching_applications_in_K8S/nginx-init-svc.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-init-svc
spec:
  selector:
    app: nginx
  ports:
    - name: nginx
      protocol: TCP
      port: 80
      targetPort: 80
```

![изображение](https://github.com/user-attachments/assets/cc57e0f9-f9f6-4030-9f97-4b3e0444c409)

4. Продемонстрировать состояние пода до и после запуска сервиса.

![изображение](https://github.com/user-attachments/assets/a7ebc5ff-7368-48c4-9018-bfece8f3046a)


------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
