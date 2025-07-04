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

3. Решить возникшую проблему с помощью ConfigMap.

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-config
data:
  HTTP_PORT: "8080"
```

4. Продемонстрировать, что pod стартовал и оба конейнера работают.

![изображение](https://github.com/user-attachments/assets/6e032bb6-4a11-496e-a768-e614ca9b1ec6)

6. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.

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

8. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём GitHub-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
