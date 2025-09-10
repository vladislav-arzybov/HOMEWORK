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

<img width="572" height="151" alt="изображение" src="https://github.com/user-attachments/assets/b48584a8-e508-4024-8a46-58f89dc9a76e" />
 
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
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ] 
```

<img width="1359" height="119" alt="изображение" src="https://github.com/user-attachments/assets/1e3a369f-507b-40f6-9f9b-9863379d9cae" />

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

#### Проверяем подключение к БД и репликацию данных

> Подключаемся на MASTER и выбираем ранее созданную БД netology_db

<img width="239" height="217" alt="изображение" src="https://github.com/user-attachments/assets/7a74e21d-c6b6-4986-984d-9593b9eb3781" />

> Создаем таблицу users, которая будет содержать цифровое ID пользователя (генерируется автоматически) и имя пользователя до 64 символов. 

<img width="1132" height="244" alt="изображение" src="https://github.com/user-attachments/assets/97c43562-61fb-4311-b9d2-18ca20769415" />

> Проверяем наличие данных на сервере REPLICA

<img width="285" height="174" alt="изображение" src="https://github.com/user-attachments/assets/6cf8e76b-50d1-41d4-960e-7572757c0dcc" />

 

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.

```
#Новые подсети для кластера K8S
resource "yandex_vpc_subnet" "public-a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}
resource "yandex_vpc_subnet" "public-b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}
resource "yandex_vpc_subnet" "public-d" {
  name           = "public-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.13.0/24"]
}
```
 
 - Создать отдельный сервис-аккаунт с необходимыми правами.

<img width="396" height="95" alt="изображение" src="https://github.com/user-attachments/assets/17524b55-0549-4bac-88a5-93213d698933" />

 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.

<img width="456" height="387" alt="изображение" src="https://github.com/user-attachments/assets/273540a5-fd0e-4eb4-87d6-a8861d390622" />

 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.

```
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }
.
.
.
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  description       = "key for k8s"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}
```

 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.

```
  scale_policy {
    auto_scale {
      initial = 3
      min = 3
      max = 6
    }
  }
```

<img width="1427" height="166" alt="изображение" src="https://github.com/user-attachments/assets/f6f5b537-e424-4ff4-a73a-f3b08734da28" />


 - Подключиться к кластеру с помощью `kubectl`.

> Добавляем параметры для подключения в конфиг ~/.kube/config

> Проверяем доступность кластера и созданных нод с запущенными подами: kubectl get pods -ALL -o wide

<img width="1647" height="455" alt="изображение" src="https://github.com/user-attachments/assets/6d182c60-42c1-4eac-acd3-6c17165883f8" />

 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.

> yaml

<img width="531" height="90" alt="изображение" src="https://github.com/user-attachments/assets/ae2a6376-0b9f-41d7-b703-ec143a797d4b" />

 
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.

> yaml

<img width="681" height="70" alt="изображение" src="https://github.com/user-attachments/assets/9647eee6-aaed-4476-a148-a89afc20d9ef" />

> Проверяем создание сервиса LoadBalancer (EXT) в кластере

<img width="1390" height="113" alt="изображение" src="https://github.com/user-attachments/assets/58089c0b-00e1-48d9-83ee-c7243cdb16ff" />

> И автоматическое создание Network Load Balancer в облаке, с адресом 158.160.134.232

<img width="740" height="592" alt="изображение" src="https://github.com/user-attachments/assets/ce2a64b1-4892-42a1-9e9a-69b97ecf3b3d" />

> В браузере на ПК выполняем опдключение на 158.160.134.232:80, проверяем доступность БД и наличие тестовой записи с пользователем.

<img width="1126" height="475" alt="изображение" src="https://github.com/user-attachments/assets/5efbc223-ae92-4db0-859f-6adbd31d93fa" />

[Код Terraform](https://github.com/vladislav-arzybov/HOMEWORK/tree/main/22_Project_organization_using_cloud_providers/04_Klastery_Resursy_pod_upravleniem_oblachnyh_provajderov/04_terraform)

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
