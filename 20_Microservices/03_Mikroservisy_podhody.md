# Домашнее задание к занятию «Микросервисы: подходы» - `Арзыбов Владислав`

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.


## Задача 1: Обеспечить разработку

Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- облачная система;
- система контроля версий Git;
- репозиторий на каждый сервис;
- запуск сборки по событию из системы контроля версий;
- запуск сборки по кнопке с указанием параметров;
- возможность привязать настройки к каждой сборке;
- возможность создания шаблонов для различных конфигураций сборок;
- возможность безопасного хранения секретных данных (пароли, ключи доступа);
- несколько конфигураций для сборки из одного репозитория;
- кастомные шаги при сборке;
- собственные докер-образы для сборки проектов;
- возможность развернуть агентов сборки на собственных серверах;
- возможность параллельного запуска нескольких сборок;
- возможность параллельного запуска тестов.

Обоснуйте свой выбор.

Большая часть современных решений соответствует требованиям указанным выше, например:

- GitLab CI/CD - использует файл конфигурации YAML в репозитории проекта для определения правил работы на каждом этапе в пайплайне. Поддерживает использование Docker-образов для определения окружения сборки.
- Jenkins - предлагает обширный набор плагинов, что позволяет интегрировать его с различными системами контроля версий, инструментами тестирования и платформами для развёртывания. Есть возможность параллельного запуска задач.
- TeamCity - поддерживает работу с различными языками программирования и может интегрироваться с разными системами контроля версий. Позволяет просматривать результаты тестов на лету, видеть покрытие кода и находить дубли.

Со своей стороны могу предложить возпользоваться GitLab. В первую очередь за счет того что GitLab-server можно развернуть и настроить как на локальной машине в докере, так и в облаке. GitLab прост в использовании, поскольку сборки можно запускать через GitLab CI shell executor (как любую программу для терминала). Задачи в GitLab могут выполняться как последовательно так и параллельно. Доступ к репозиториям настраивается в соответствии с группой пользователя, что повышает безопасность проекта. Также GitLab предлагает инструменты для тестирования и оценки качества кода, что помогает быстрее находить и исправлять ошибки.

## Задача 2: Логи

Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор логов в центральное хранилище со всех хостов, обслуживающих систему;
- минимальные требования к приложениям, сбор логов из stdout;
- гарантированная доставка логов до центрального хранилища;
- обеспечение поиска и фильтрации по записям логов;
- обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
- возможность дать ссылку на сохранённый поиск по записям логов.

Обоснуйте свой выбор.

Под указанные выше требования хорошо подойдет решение в виде ELK. Стек ELK – это универсальный набор инструментов для сбора, хранения, обработки и анализа логов, который широко применяется в корпоративных информационных системах. Он оптимизирует работу с данными, упрощает поиск проблем в приложениях и способствует более глубокому пониманию процессов внутри IT-инфраструктуры. Каждый элемент внутри стека выполняет собственную роль, основными из которых являются: Elasticsearch, Logstash, Kibana и Beats. Их сочетание закрывает все основные потребности по сбору, агрегации, хранению, анализу и визуализации логов (журналов).

Elasticsearch – основа хранения и поиска данных. Высокопроизводительный поисковый движок, ориентированный на хранение больших массивов логов и контент-файлов. 

Logstash – сбор и обработка логов. Серверный инструмент, занимающий центральное место в процессе сбора и первичной обработки. Он получает журналы из разных источников (приложение, сервер, внешняя система) и преобразует их в унифицированный формат. 

Kibana – визуализация логов и мониторинг. Веб-инструмент, который позволяет построить удобные дашборды и просматривать метрики в режиме реального времени. После того как логи (journal) будут сохранены в Elasticsearch, Kibana предоставляет наглядную аналитику: графики, диаграммы, карты и таблицы. 

Beats – дополнительные агенты для сбора данных которые устанавливаются на серверах, в приложениях или в контейнерах для сбора различных метрик и логов. К примеру, Filebeat парсит текстовые логи, а Metricbeat контролирует системные метрики (CPU, память, диск).


## Задача 3: Мониторинг

Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор метрик со всех хостов, обслуживающих систему;
- сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
- сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
- сбор метрик, специфичных для каждого сервиса;
- пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
- пользовательский интерфейс с возможностью настраивать различные панели для отслеживания состояния системы.

Обоснуйте свой выбор.

Наиболее популярным решением будет использование стека Prometheus и Grafana.

В роли инструмента для сбора метрик с хостов (серверов) и дальнейшего предоставления их Prometheus будет выступать Node Exporter.
В свою очередь у Prometheus есть поддержка временных рядов данных, что позволяет анализировать изменения в системе с учетом времи, также система позволяет создавать сложные запросы к собранным данным для их анализа.
Встроенная система алертинга в Prometheus может отправлять оповещения (алерты), на основе заренее установленных правил.
Prometheus поддерживает интеграцию с другими инструментами, например со средствами визуализации, упрощая работу с данными и создавая удобные дашборды для анализа. Таким образом Grafana помогает представлять сложные метрики Prometheus в виде понятных графиков.


## Задача 4: Логи * (необязательная)

Продолжить работу по задаче API Gateway: сервисы, используемые в задаче, пишут логи в stdout. 

Добавить в систему сервисы для сбора логов Vector + ElasticSearch + Kibana со всех сервисов, обеспечивающих работу API.

### Результат выполнения: 

docker compose файл, запустив который можно перейти по адресу http://localhost:8081, по которому доступна Kibana.
Логин в Kibana должен быть admin, пароль qwerty123456.


## Задача 5: Мониторинг * (необязательная)

Продолжить работу по задаче API Gateway: сервисы, используемые в задаче, предоставляют набор метрик в формате prometheus:

- сервис security по адресу /metrics,
- сервис uploader по адресу /metrics,
- сервис storage (minio) по адресу /minio/v2/metrics/cluster.

Добавить в систему сервисы для сбора метрик (Prometheus и Grafana) со всех сервисов, обеспечивающих работу API.
Построить в Graphana dashboard, показывающий распределение запросов по сервисам.

### Результат выполнения: 

docker compose файл, запустив который можно перейти по адресу http://localhost:8081, по которому доступна Grafana с настроенным Dashboard.
Логин в Grafana должен быть admin, пароль qwerty123456.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
