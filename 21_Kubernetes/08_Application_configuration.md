# Домашнее задание к занятию «Конфигурация приложений» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-multitool
spec:
  replicas: 1
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
          valueFrom:
            configMapKeyRef:
              name: env-config
              key: HTTP_PORT
```

2. Решить возникшую проблему с помощью ConfigMap.

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-config
data:
  HTTP_PORT: "8080"
```

3. Продемонстрировать, что pod стартовал и оба конейнера работают.

![изображение](https://github.com/user-attachments/assets/6e032bb6-4a11-496e-a768-e614ca9b1ec6)

4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.

```
        volumeMounts:
        - name: web-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: web-html
        configMap:
          name: env-config
```

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-config
data:
  HTTP_PORT: "8080"
  index.html: |
    <html>
    <body>
      <h1>test</h1>
    </body>
    </html>
```

![изображение](https://github.com/user-attachments/assets/ebdf0c5a-0336-4fc0-abc5-a6544caf617f)

#### kubectl get svc -o wide

![изображение](https://github.com/user-attachments/assets/70e8a5be-b4bb-4660-a876-7b382615f1ad)

5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ng-deployment
spec:
  replicas: 1
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

3. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.

```
        volumeMounts:
        - name: web-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: web-html
        configMap:
          name: ng-config

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ng-config
data:
  index.html: |
    <html>
    <body>
      <h1>test</h1>
    </body>
    </html>
```

5. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.

#### openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=localhost/O=localhost"

![изображение](https://github.com/user-attachments/assets/0e7b5836-7a50-4476-837a-d41a8c35b27c)

#### kubectl create secret tls web-tls --cert=tls.crt --key=tls.key

![изображение](https://github.com/user-attachments/assets/3e591b79-87b8-405f-b771-81d4dfc36e9a)

7. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS.

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ng-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  tls:
    - hosts:
      - localhost
      secretName: web-tls
  rules:
  - host: localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ng-svc
            port:
              number: 80
```

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

4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
