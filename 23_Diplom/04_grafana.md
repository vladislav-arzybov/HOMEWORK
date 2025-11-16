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
kubectl apply --server-side -f manifests/setup

# Проверяем факт установки всех CRD(CustomResourceDefinition), наличия состояния = Established
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring

# Разворачиваем систему мониторинга, устанавливаем Prometheus, Alertmanager, Grafana и т.д.
kubectl apply -f manifests/
```

2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

> Установка

```
git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus


kubectl apply --server-side -f manifests/setup

kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring

kubectl apply -f manifests/
```

> Проверка статуса пода, ошибки
- kubectl describe pod alertmanager-main-1 -n monitoring
