### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.

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

<img width="1801" height="953" alt="изображение" src="https://github.com/user-attachments/assets/15aae926-20d6-4be3-922d-8855512c6903" />

> Также можно посмотреть нагрузку на master-node и worker-node's

<details>
  <summary>Dashboard</summary>

<img width="1807" height="949" alt="изображение" src="https://github.com/user-attachments/assets/fbce25f7-0ed9-401e-a30d-0d5ef4e168cd" />

<img width="1801" height="953" alt="изображение" src="https://github.com/user-attachments/assets/f5e6d53d-bf7c-4511-ab51-6a8144f4409b" />

<img width="1801" height="951" alt="изображение" src="https://github.com/user-attachments/assets/16ca7504-9c10-4620-823f-3bdba61332d8" />


</details>

2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).


<img width="1349" height="193" alt="изображение" src="https://github.com/user-attachments/assets/ca429f53-6fcb-4cf2-87ed-fd315fd4b839" />



Править?

/home/reivol/Terraform2/05_diplom/kube-prometheus/manifests/grafana-service.yaml
