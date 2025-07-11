# Домашнее задание к занятию «Helm» - `Арзыбов Владислав`

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения.

<img width="385" height="37" alt="изображение" src="https://github.com/user-attachments/assets/79ce2feb-033d-4d6e-ad6d-88f07590bf39" />

2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.

[]()

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
  labels:
    app: {{ .Release.Name }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
      - name: nginx
        image: {{ .Values.image.name }}:{{ .Values.image.tag | default .Chart.AppVersion }}
        volumeMounts:
        - name: web-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: web-html
        configMap:
          name: configmap-{{ .Release.Name }}
```

[]()

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-{{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
data:
  index.html: |
    <html>
    <body>
      <h1>Welcome to {{ .Release.Namespace }}-{{ .Release.Name }}</h1>
    </body>
    </html>
```

[]()

```
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
  namespace: {{ .Release.Namespace }}
spec:
  selector:
    app: {{ .Release.Name }}
  type: NodePort
  ports:
    - name: nginx-np
      protocol: TCP
      port: 80
      targetPort: 80
```

3. В переменных чарта измените образ приложения для изменения версии.

Версию приложения можно изменить как через ```appVersion``` в ```Chart.yaml```

[]()

```
apiVersion: v2
name: my-chart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
```

<details>
  <summary>helm template nginx1 . -n app1</summary>


  ```bash
---
# Source: my-chart/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-nginx1
  namespace: app1
data:
  index.html: |
    <html>
    <body>
      <h1>Welcome to app1-nginx1</h1>
    </body>
    </html>
---
# Source: my-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx1
  namespace: app1
spec:
  selector:
    app: nginx1
  type: NodePort
  ports:
    - name: nginx-np
      protocol: TCP
      port: 80
      targetPort: 80
---
# Source: my-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx1
  namespace: app1
  labels:
    app: nginx1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx1
  template:
    metadata:
      labels:
        app: nginx1
    spec:
      containers:
      - name: nginx
        image: nginx:1.16.0
        volumeMounts:
        - name: web-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: web-html
        configMap:
          name: configmap-nginx1
```  

</details>

Также версию можно изменить через поле ```tag``` в ```values.yaml```

[]()

```
image:
  name: nginx
  tag: latest
```

<details>
  <summary>helm template nginx1 . -n app1</summary>


  ```bash
---
# Source: my-chart/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-nginx1
  namespace: app1
data:
  index.html: |
    <html>
    <body>
      <h1>Welcome to app1-nginx1</h1>
    </body>
    </html>
---
# Source: my-chart/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx1
  namespace: app1
spec:
  selector:
    app: nginx1
  type: NodePort
  ports:
    - name: nginx-np
      protocol: TCP
      port: 80
      targetPort: 80
---
# Source: my-chart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx1
  namespace: app1
  labels:
    app: nginx1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx1
  template:
    metadata:
      labels:
        app: nginx1
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        volumeMounts:
        - name: web-html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: web-html
        configMap:
          name: configmap-nginx1
```  

</details>

------
### Задание 2. Запустить две версии в разных неймспейсах

Предварительно создадим два новых namespace app1 и app2
- kubectl create namespace app1
- kubectl create namespace app2

<img width="524" height="137" alt="изображение" src="https://github.com/user-attachments/assets/06ed3771-a001-4730-b250-d53a7a8739e9" />

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

