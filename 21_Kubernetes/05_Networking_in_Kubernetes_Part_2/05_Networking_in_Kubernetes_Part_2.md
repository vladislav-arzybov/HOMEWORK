# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.

[ng-deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/05_Networking_in_Kubernetes_Part_2/ng-deployment.yml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: ng-container
        image: nginx:latest
        ports:
        - containerPort: 80
```

![изображение](https://github.com/user-attachments/assets/c1044321-7bd7-40ba-b12b-12363def8cc4)

2. Создать Deployment приложения _backend_ из образа multitool. 

[mt-deployment.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/05_Networking_in_Kubernetes_Part_2/mt-deployment.yml)

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: multitool
  template:
    metadata:
      labels:
        app: multitool
    spec:
      containers:
      - name: mt-container
        image: wbitt/network-multitool
        ports:
        - containerPort: 80
```

![изображение](https://github.com/user-attachments/assets/cef636df-2c16-4d13-939b-573ea3f131bd)

3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера.

[ng-svc.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/05_Networking_in_Kubernetes_Part_2/ng-svc.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: ng-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

[mt-svc.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/05_Networking_in_Kubernetes_Part_2/mt-svc.yml)

```
apiVersion: v1
kind: Service
metadata:
  name: mt-service
spec:
  selector:
    app: multitool
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

#### kubectl get svc -o wide

![изображение](https://github.com/user-attachments/assets/f7479911-529c-4b32-a968-b34f5be1b99c)

4. Продемонстрировать, что приложения видят друг друга с помощью Service.

#### kubectl exec -ti backend-7477875577-sx2w9 -- bash

![изображение](https://github.com/user-attachments/assets/a2098ec4-90cf-4b6f-a2e3-bf70be2b05fc)

#### kubectl exec -ti frontend-6f479fff4d-46kpv -- bash

![изображение](https://github.com/user-attachments/assets/2a345448-b78a-4875-a0b0-5735815f4716)

5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.

#### microk8s enable ingress

![изображение](https://github.com/user-attachments/assets/d17d7e53-9ea8-4bd7-ab86-b3edc30bc179)

2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.

[ingress.yml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/21_Kubernetes/05_Networking_in_Kubernetes_Part_2/ingress.yml)

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: localhost
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: mt-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ng-service
            port:
              number: 80
```

![изображение](https://github.com/user-attachments/assets/2f0c4264-688d-4b0f-be76-3940eb02d820)

3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.

![изображение](https://github.com/user-attachments/assets/db1048d3-4491-4df9-ac13-59995b1c1c60)

4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
