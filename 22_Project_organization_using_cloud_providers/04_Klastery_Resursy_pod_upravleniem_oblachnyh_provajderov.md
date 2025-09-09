# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

### Цели задания 

1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.

---
## Задание 1. Yandex Cloud

1. Настроить с помощью Terraform кластер баз данных MySQL.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость.

> Создаем дополнительные подсети

```
#Новые подсети для кластера MySQL
resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.21.0/24"]
}
resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.22.0/24"]
}
```
 
 - Разместить ноды кластера MySQL в разных подсетях.

> В зоне d недоступна конфигурация Intel Broadwell поэтому количество нод сокращено до двух, мастер и реплика.

```
  resources {
    resource_preset_id = "b1.medium" #Класс хоста
    disk_type_id       = "network-hdd"
    disk_size          = "20"
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private-a.id
    name             = "db-1"
    assign_public_ip = "true" #разрешить_публичный_доступ_к_хосту
    priority         = "100" #приоритет_при_выборе_хоста-мастера
    backup_priority  = "100" #приоритет_для_резервного_копирования
  }
  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.private-b.id
    name             = "db-2"
    assign_public_ip = "true"
    priority         = "10"
    backup_priority  = "10"
  }
```

<img width="1359" height="119" alt="изображение" src="https://github.com/user-attachments/assets/1e3a369f-507b-40f6-9f9b-9863379d9cae" />
 
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.

```
  maintenance_window {  #время технического обслуживания
    type = "ANYTIME"
  }
```
 
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.

```
resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = "MySQL-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.prod-vpc.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ] #security_group опционально
```

 - Задать время начала резервного копирования — 23:59.

```
  backup_window_start {  #время начала резервного копирования
    hours   = "23"
    minutes = "59"
  }
```
 
 - Включить защиту кластера от непреднамеренного удаления.

```
  deletion_protection = "true"
```

 - Создать БД с именем `netology_db`, логином и паролем.

```
#DataBase
resource "yandex_mdb_mysql_database" "mysql" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_db"
}
#User
resource "yandex_mdb_mysql_user" "user1" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "reivol"
  password   = "1qaz@WSX" #or generate_password
  #generate_password = true #сгенерировать password
  permission {
    database_name = yandex_mdb_mysql_database.mysql.name
    roles         = ["ALL"]
  }
}
```

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.
 - Создать отдельный сервис-аккаунт с необходимыми правами. 
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
 - Подключиться к кластеру с помощью `kubectl`.
 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.

Полезные документы:

- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster).
- [Создание кластера Kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster).
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).

--- 
## Задание 2*. Вариант с AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. Настроить с помощью Terraform кластер EKS в три AZ региона, а также RDS на базе MySQL с поддержкой MultiAZ для репликации и создать два readreplica для работы.
 
 - Создать кластер RDS на базе MySQL.
 - Разместить в Private subnet и обеспечить доступ из public сети c помощью security group.
 - Настроить backup в семь дней и MultiAZ для обеспечения отказоустойчивости.
 - Настроить Read prelica в количестве двух штук на два AZ.

2. Создать кластер EKS на базе EC2.

 - С помощью Terraform установить кластер EKS на трёх EC2-инстансах в VPC в public сети.
 - Обеспечить доступ до БД RDS в private сети.
 - С помощью kubectl установить и запустить контейнер с phpmyadmin (образ взять из docker hub) и проверить подключение к БД RDS.
 - Подключить ELB (на выбор) к приложению, предоставить скрин.

Полезные документы:

- [Модуль EKS](https://learn.hashicorp.com/tutorials/terraform/eks).

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
