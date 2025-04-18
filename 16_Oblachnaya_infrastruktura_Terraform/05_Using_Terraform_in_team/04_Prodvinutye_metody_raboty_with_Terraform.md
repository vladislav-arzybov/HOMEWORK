# Домашнее задание к занятию «Продвинутые методы работы с Terraform» - `Арзыбов Владислав`

### Цели задания

1. Научиться использовать модули.
2. Отработать операции state.
3. Закрепить пройденный материал.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**04/src**](https://github.com/netology-code/ter-homeworks/tree/main/04/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------
### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания с помощью двух вызовов remote-модуля -> двух ВМ, относящихся к разным проектам(marketing и analytics) используйте labels для обозначения принадлежности.  В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.

```
#Пример передачи cloud-config в ВМ
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

    vars = {
    username           = var.username
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
  }

}
```

2. Добавьте в файл cloud-init.yml установку nginx.

```
#cloud-config
users:
  - name: ${username}
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${ssh_public_key}
package_update: true
package_upgrade: false
packages:
  - vim
  - nginx

```

3. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```, скриншот консоли ВМ yandex cloud с их метками. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.marketing_vm

![изображение](https://github.com/user-attachments/assets/98192c45-34b3-44e8-a17f-ed1a90a2ba3c)

![изображение](https://github.com/user-attachments/assets/e505fdda-c278-4b3a-ac86-f9396a63d42b)

![изображение](https://github.com/user-attachments/assets/fec0c028-25d7-4152-ac47-faf7ab91cf15)

![изображение](https://github.com/user-attachments/assets/f879377f-e778-437e-876a-63d051ee07b0)

<details>
  <summary>module.marketing_vm</summary>

  ```bash

{
  "external_ip_address" = [
    "89.169.156.86",
  ]
  "fqdn" = [
    "develop-webs-0.ru-central1.internal",
  ]
  "internal_ip_address" = [
    "10.0.1.4",
  ]
  "labels" = [
    tomap({
      "owner" = "v.arzybov"
      "project" = "marketing"
    }),
  ]
  "network_interface" = [
    tolist([
      {
        "dns_record" = tolist([])
        "index" = 0
        "ip_address" = "10.0.1.4"
        "ipv4" = true
        "ipv6" = false
        "ipv6_address" = ""
        "ipv6_dns_record" = tolist([])
        "mac_address" = "d0:0d:ac:e9:b4:18"
        "nat" = true
        "nat_dns_record" = tolist([])
        "nat_ip_address" = "89.169.156.86"
        "nat_ip_version" = "IPV4"
        "security_group_ids" = toset([])
        "subnet_id" = "e9bv5b4fvurhqg1n738f"
      },
    ]),
  ]
}

```  

</details>

<details>
  <summary>module.analytics_vm</summary>

  ```bash

{
  "external_ip_address" = [
    "89.169.134.73",
  ]
  "fqdn" = [
    "stage-web-stage-0.ru-central1.internal",
  ]
  "internal_ip_address" = [
    "10.0.1.26",
  ]
  "labels" = [
    tomap({
      "owner" = "v.arzybov"
      "project" = "analytics"
    }),
  ]
  "network_interface" = [
    tolist([
      {
        "dns_record" = tolist([])
        "index" = 0
        "ip_address" = "10.0.1.26"
        "ipv4" = true
        "ipv6" = false
        "ipv6_address" = ""
        "ipv6_dns_record" = tolist([])
        "mac_address" = "d0:0d:86:f7:2c:e2"
        "nat" = true
        "nat_dns_record" = tolist([])
        "nat_ip_address" = "89.169.134.73"
        "nat_ip_version" = "IPV4"
        "security_group_ids" = toset([])
        "subnet_id" = "e9bv5b4fvurhqg1n738f"
      },
    ]),
  ]
}

```  

</details>

------
В случае использования MacOS вы получите ошибку "Incompatible provider version" . В этом случае скачайте remote модуль локально и поправьте в нем версию template провайдера на более старую.
------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля, например: ```ru-central1-a```.
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.
3. Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev

![изображение](https://github.com/user-attachments/assets/11ae8a08-7829-4856-9d1d-b43b57e13f98)
 
4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
5. Сгенерируйте документацию к модулю с помощью terraform-docs.

[doc.md](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/16_Oblachnaya_infrastruktura_Terraform/doc.md)

[doc_vpc.md](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/16_Oblachnaya_infrastruktura_Terraform/doc_vpc.md)
 
Пример вызова

```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

### Задание 3
1. Выведите список ресурсов в стейте.

![изображение](https://github.com/user-attachments/assets/c619048c-c5c8-49e3-a513-72c1c5d50967)

```
reivol@Zabbix:~/GitHub/ter-homeworks/04/src$ terraform state show module.analytics_vm.yandex_compute_instance.vm[0] | grep -P ' id |image_id ' 
    id          = "fhmt37kq2cge288qbnus"
    image_id    = "fd805090je9atk2b9jon"

reivol@Zabbix:~/GitHub/ter-homeworks/04/src$ terraform state show module.marketing_vm.yandex_compute_instance.vm[0] | grep -P ' id |image_id '
    id          = "fhmmpeubp03rfdet29ja"
    image_id    = "fd805090je9atk2b9jon"

reivol@Zabbix:~/GitHub/ter-homeworks/04/src$ terraform state show module.vpc_dev.yandex_vpc_subnet.develop | grep -P ' id |network_id'
    id             = "e9bqhs9earuj02gsmdn4"
    network_id     = "enpnt29pial4a6671p6d"
```

2. Полностью удалите из стейта модуль vpc.

![изображение](https://github.com/user-attachments/assets/345976a4-4039-4f8f-9d89-e77cc4f669fb)
  
3. Полностью удалите из стейта модуль vm.

![изображение](https://github.com/user-attachments/assets/71aa9053-9db2-4269-849c-de4af2be7fee)

4. Импортируйте всё обратно. Проверьте terraform plan. Значимых(!!) изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.

- terraform import 'module.vpc_dev.yandex_vpc_network.develop' 'enpnt29pial4a6671p6d'

![изображение](https://github.com/user-attachments/assets/fb8eb21e-3522-4fd7-95b3-07571672227f)

- terraform import 'module.vpc_dev.yandex_vpc_subnet.develop' 'e9bqhs9earuj02gsmdn4'

![изображение](https://github.com/user-attachments/assets/1f549c12-384a-4845-94ed-b5791440718d)

![изображение](https://github.com/user-attachments/assets/5566f883-2fd2-4220-b457-59339e6f2475)

- terraform import 'module.analytics_vm.yandex_compute_instance.vm[0]' 'fhmt37kq2cge288qbnus'

![изображение](https://github.com/user-attachments/assets/06caf5cf-1059-41ed-8f8a-784b7a94b37e)

- terraform import 'module.marketing_vm.yandex_compute_instance.vm[0]' 'fhmmpeubp03rfdet29ja'

![изображение](https://github.com/user-attachments/assets/024eedd8-4b77-4d7e-8318-b62614c67865)

![изображение](https://github.com/user-attachments/assets/41607814-f5f4-4512-92f4-879f9299372b)

- terraform plan

![изображение](https://github.com/user-attachments/assets/a1b741b1-4ade-4312-b9c1-379ebecf5257)


## Дополнительные задания (со звёздочкой*)

**Настоятельно рекомендуем выполнять все задания со звёздочкой.**   Они помогут глубже разобраться в материале.   
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```

Предоставьте код, план выполнения, результат из консоли YC.

### Задание 5*

1. Напишите модуль для создания кластера managed БД Mysql в Yandex Cloud с одним или несколькими(2 по умолчанию) хостами в зависимости от переменной HA=true или HA=false. Используйте ресурс yandex_mdb_mysql_cluster: передайте имя кластера и id сети.
2. Напишите модуль для создания базы данных и пользователя в уже существующем кластере managed БД Mysql. Используйте ресурсы yandex_mdb_mysql_database и yandex_mdb_mysql_user: передайте имя базы данных, имя пользователя и id кластера при вызове модуля.
3. Используя оба модуля, создайте кластер example из одного хоста, а затем добавьте в него БД test и пользователя app. Затем измените переменную и превратите сингл хост в кластер из 2-х серверов.
4. Предоставьте план выполнения и по возможности результат. Сразу же удаляйте созданные ресурсы, так как кластер может стоить очень дорого. Используйте минимальную конфигурацию.

### Задание 6*
1. Используя готовый yandex cloud terraform module и пример его вызова(examples/simple-bucket): https://github.com/terraform-yc-modules/terraform-yc-s3 .
Создайте и не удаляйте для себя s3 бакет размером 1 ГБ(это бесплатно), он пригодится вам в ДЗ к 5 лекции.

### Задание 7*

1. Разверните у себя локально vault, используя docker-compose.yml в проекте.
2. Для входа в web-интерфейс и авторизации terraform в vault используйте токен "education".
3. Создайте новый секрет по пути http://127.0.0.1:8200/ui/vault/secrets/secret/create
Path: example  
secret data key: test 
secret data value: congrats!  
4. Считайте этот секрет с помощью terraform и выведите его в output по примеру:
```
provider "vault" {
 address = "http://<IP_ADDRESS>:<PORT_NUMBER>"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 

Можно обратиться не к словарю, а конкретному ключу:
terraform console: >nonsensitive(data.vault_generic_secret.vault_example.data.<имя ключа в секрете>)
```
5. Попробуйте самостоятельно разобраться в документации и записать новый секрет в vault с помощью terraform. 

### Задание 8*
Попробуйте самостоятельно разобраться в документаци и с помощью terraform remote state разделить root модуль на два отдельных root-модуля: создание VPC , создание ВМ . 

### Правила приёма работы

В своём git-репозитории создайте новую ветку terraform-04, закоммитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-04.

В качестве результата прикрепите ссылку на ветку terraform-04 в вашем репозитории.

**Важно.** Удалите все созданные ресурсы.

### Критерии оценки

Зачёт ставится, если:

* выполнены все задания,
* ответы даны в развёрнутой форме,
* приложены соответствующие скриншоты и файлы проекта,
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку работу отправят, если:

* задание выполнено частично или не выполнено вообще,
* в логике выполнения заданий есть противоречия и существенные недостатки. 
