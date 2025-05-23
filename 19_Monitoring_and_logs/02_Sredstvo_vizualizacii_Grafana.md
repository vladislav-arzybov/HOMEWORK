# Домашнее задание к занятию 14 «Средство визуализации Grafana» - `Арзыбов Владислав`

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

![изображение](https://github.com/user-attachments/assets/3dd6ce7b-4604-459b-bb64-3602ce12f4c3)

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.

![изображение](https://github.com/user-attachments/assets/47e9d0a0-e421-4a44-9b9f-c13358652a3f)

2. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.

![изображение](https://github.com/user-attachments/assets/15e550ae-7dc6-43b0-9025-d6bcef372ca4)

3. Подключите поднятый вами prometheus, как источник данных.

![изображение](https://github.com/user-attachments/assets/84b1c98d-56f0-48f0-a8b7-55bdaa926b1d)

4. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

![изображение](https://github.com/user-attachments/assets/3f2b6d69-5813-4b1d-b10b-eeb54dbd46f8)


## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);

```
100 - (avg by (instance) (rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[1m])) * 100)
```

- CPULA 1/5/15;

```
- node_load1{instance="nodeexporter:9100",job="nodeexporter"}
- node_load5{instance="nodeexporter:9100",job="nodeexporter"}
- node_load15{instance="nodeexporter:9100",job="nodeexporter"}
```

- количество свободной оперативной памяти;

```
node_memory_MemFree_bytes{instance="nodeexporter:9100",job="nodeexporter"} + node_memory_MemAvailable_bytes{instance="nodeexporter:9100",job="nodeexporter"}
```

- количество места на файловой системе.

```
node_filesystem_avail_bytes{fstype=~"ext4|xfs",instance="nodeexporter:9100",job="nodeexporter"}
```

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

![изображение](https://github.com/user-attachments/assets/6e30d486-da82-4cce-b4eb-b2254bca28b4)


## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».

![изображение](https://github.com/user-attachments/assets/97784735-0dfc-416b-aaa6-486a856a6997)

2. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

![изображение](https://github.com/user-attachments/assets/d46a9c78-fff5-4c22-aa76-37d20ac04b51)

![изображение](https://github.com/user-attachments/assets/809f1501-e086-40cb-84df-d884b62ee875)

Тестирование мониторингов при нагрузке системы:

![изображение](https://github.com/user-attachments/assets/b554d9b1-445c-4d7a-9241-3771b24f0628)

![изображение](https://github.com/user-attachments/assets/78a2a082-1750-49e7-9c08-479fb4602a2c)

Получение уведомлений

![изображение](https://github.com/user-attachments/assets/18b9cfb6-af05-4e0b-b054-dd1478a9eb22)

![изображение](https://github.com/user-attachments/assets/0adf6969-9541-4fe1-88b2-f7252349e654)

![изображение](https://github.com/user-attachments/assets/e09371d8-76d5-4a5d-b94a-dd3d9fbce6ec)



## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

[dashboard.json](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/19_Monitoring_and_logs/dashboard.json)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
