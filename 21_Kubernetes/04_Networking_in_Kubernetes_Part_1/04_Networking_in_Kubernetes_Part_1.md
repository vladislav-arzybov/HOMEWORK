# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.

[deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/04_Networking_in_Kubernetes_Part_1/deployment.yml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-multitool
spec:
  replicas: 3
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
          value: '8080'
```

![изображение](https://github.com/user-attachments/assets/c8161b4e-bf6d-4559-ab7e-64fbcdd82b58)

2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.

[svc.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/04_Networking_in_Kubernetes_Part_1/svc.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: svc
spec:
  selector:
    app: nginx-multitool
  ports:
    - name: nginx-port
      protocol: TCP
      port: 9001
      targetPort: 80
    - name: multitool-port
      protocol: TCP
      port: 9002
      targetPort: 8080
```

![изображение](https://github.com/user-attachments/assets/1c52e823-f500-44a8-85cd-c76a3f406001)


3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.

[multitool-pod.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/04_Networking_in_Kubernetes_Part_1/multitool-pod.yml)

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

![изображение](https://github.com/user-attachments/assets/30393177-0a2c-40a1-9eea-59549a6ea6a8)

#### kubectl exec -it multitool -- bash

![изображение](https://github.com/user-attachments/assets/38d3f0ac-352c-45d3-bde8-b6d982d136f0)

4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.

- #### curl svc.default.svc.cluster.local:9001
- #### curl svc.default.svc.cluster.local:9002

![изображение](https://github.com/user-attachments/assets/c7019d12-653c-4c8f-8512-0f9b135c5a55)

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.

[svc-np.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/04_Networking_in_Kubernetes_Part_1/svc-np.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: svc-np
spec:
  selector:
    app: nginx-multitool
  type: NodePort
  ports:
    - name: nginx-np
      protocol: TCP
      port: 9001
      targetPort: 80
    - name: multitool-np
      protocol: TCP
      port: 9002
      targetPort: 8080
```

![изображение](https://github.com/user-attachments/assets/0353352a-5702-4a57-b6e1-26f9a474422a)

2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

![изображение](https://github.com/user-attachments/assets/368541fd-9ae0-4a74-8705-162a607b791d)

3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

