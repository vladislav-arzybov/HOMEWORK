### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

> Для развертывания системы мониторинга воспользуемся пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus) который уже включает в себя всё вышеперечисленное.

- git clone https://github.com/prometheus-operator/kube-prometheus.git
- cd kube-prometheus

<img width="982" height="164" alt="изображение" src="https://github.com/user-attachments/assets/078815de-5c01-4c1e-8d94-8573467c1ff2" />

> Выполним последовательность команд перечисленных в README kube-prometheus

```
# Установка CRD и базовых объектов Prometheus Operator
kubectl apply --server-side -f manifests/setup/

# Проверяем факт установки всех CRD(CustomResourceDefinition), наличия состояния = Established
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring

# Разворачиваем систему мониторинга, устанавливаем Prometheus, Alertmanager, Grafana и т.д.
kubectl apply -f manifests/
```

> После завершения установки проверяем статус подов и сервисов в namespase = monitoring, ошибок нет.
- kubectl get all -n monitoring

<img width="1099" height="885" alt="изображение" src="https://github.com/user-attachments/assets/1a870683-6926-4192-847c-702fbab9c7a7" />

> Проверяем что Prometheus видит таргеты, выполняем проброс портов и открываем страницу в браузере, 
- kubectl port-forward -n monitoring svc/prometheus-k8s 9090:9090
- http://localhost:9090/targets

<img width="1805" height="571" alt="изображение" src="https://github.com/user-attachments/assets/91167555-33f4-4d92-b9f0-239a5532297a" />

> Проверяем работу графаны, заходим под admin'ом
- kubectl port-forward -n monitoring svc/grafana 3000:3000
- http://localhost:3000

<img width="1803" height="949" alt="изображение" src="https://github.com/user-attachments/assets/05b22f1b-596a-49c8-ab7f-f724282fe634" />

<img width="1799" height="965" alt="изображение" src="https://github.com/user-attachments/assets/495e7318-84f7-40e7-91ec-1fb8a98e505c" />

> Также можно посмотреть нагрузку на master-node и worker-node's

<details>
  <summary>Dashboard</summary>

<img width="1807" height="949" alt="изображение" src="https://github.com/user-attachments/assets/fbce25f7-0ed9-401e-a30d-0d5ef4e168cd" />

<img width="1801" height="953" alt="изображение" src="https://github.com/user-attachments/assets/f5e6d53d-bf7c-4511-ab51-6a8144f4409b" />

<img width="1801" height="951" alt="изображение" src="https://github.com/user-attachments/assets/16ca7504-9c10-4620-823f-3bdba61332d8" />


</details>

> Дополнительно, чтобы графана была доступна не только с локальной машины, но из из внешеней сети настраиваем новый сервис NodePort и правило NetworkPolicy

[grafana-nodeport.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/04_grafana/grafana/01_grafana-nodeport.yaml)
```
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
    app.kubernetes.io/version: 12.2.1
  name: grafana-nodeport
  namespace: monitoring
spec:
  type: NodePort
  selector:
    app.kubernetes.io/component: grafana
    app.kubernetes.io/name: grafana
    app.kubernetes.io/part-of: kube-prometheus
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
      nodePort: 30001
```
[grafana-network.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/04_grafana/grafana/02_grafana-network.yaml)
```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: grafana-external
  namespace: monitoring
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: grafana
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 0.0.0.0/0
    ports:
    - protocol: TCP
      port: 3000
```

> Запускаем установку
- kubectl apply -f 04_grafana/grafana/
- kubectl get svc -n monitoring

<img width="900" height="294" alt="изображение" src="https://github.com/user-attachments/assets/46a91659-d3e2-4efe-8a7f-04d112e79183" />

> Проверяем доступ c мастера http://158.160.122.175:30001:

<img width="1913" height="995" alt="изображение" src="https://github.com/user-attachments/assets/56b81633-be91-423f-a459-4c70d39c1dc3" />


2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

> Создаем новый namespace для приожения app-namespace.yaml

[app-namespace.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/04_grafana/app/01_app-namespace.yaml)
```
apiVersion: v1
kind: Namespace
metadata:
  name: app
  labels:
    name: app
```

> Для развертывания приложения создадим app-deployment.yaml и app-svc.yaml

[app-deployment.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/04_grafana/app/02_app-deployment.yaml)
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-app-deployment
  namespace: app
  labels:
    app: test-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test-app
  template:
    metadata:
      labels:
        app: test-app
    spec:
      containers:
      - name: nginx-docker
        image: arzybov/test-app-nginx:1.0.0
        ports:
        - containerPort: 80
```

[app-svc.yaml](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/23_Diplom/04_grafana/app/03_app-svc.yaml)
```
apiVersion: v1
kind: Service
metadata:
  name: test-app-svc
  namespace: app
spec:
  type: NodePort
  selector:
    app: test-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30002
```

> Запускаем установку, проверяем создания подов и сервиса:
- kubectl apply -f 04_grafana/app/
- kubectl get all -n app

<img width="763" height="309" alt="изображение" src="https://github.com/user-attachments/assets/f7dd08cd-7599-4635-bd9c-90169b56ac66" />

> Проверяем доступность портала с адреса мастера: http://158.160.122.175:30002

<img width="876" height="200" alt="изображение" src="https://github.com/user-attachments/assets/ff8773f0-d822-49d3-8e12-eeb637e092b0" />

