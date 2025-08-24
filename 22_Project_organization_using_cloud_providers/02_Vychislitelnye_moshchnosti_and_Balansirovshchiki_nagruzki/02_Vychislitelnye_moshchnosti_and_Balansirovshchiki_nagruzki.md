# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  - `Арзыбов Владислав`

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

[bucket.tf](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/22_Project_organization_using_cloud_providers/02_Vychislitelnye_moshchnosti_and_Balansirovshchiki_nagruzki/02_terraform/bucket.tf)

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.

<img width="1088" height="245" alt="изображение" src="https://github.com/user-attachments/assets/1ac53a34-6cd8-461f-be2c-c755c2ca2e73" />
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

[код Terraform](https://github.com/vladislav-arzybov/HOMEWORK/tree/main/22_Project_organization_using_cloud_providers/02_Vychislitelnye_moshchnosti_and_Balansirovshchiki_nagruzki/02_terraform)

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.

<img width="1364" height="213" alt="изображение" src="https://github.com/user-attachments/assets/95914741-f7a0-485b-aa29-115dc0ac0cf1" />
 
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).

> В metadata использовал cloud-init, заранее указав новые переменные через template_file

```
    metadata = {
      serial-port-enable = var.serial-port
      user-data          = data.template_file.cloudinit.rendered #Подключение через cloud-config
    }
```
```
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
    vars = {
    username           = var.username
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
    bucket_name        = yandex_storage_bucket.my-bucket.bucket_domain_name
    image_name         = yandex_storage_object.cat-picture.key
  }
}
```

 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.

> Для удобства отслеживания поключения к конкретной ВМ в cloud-config помимо вывода картинки добавил имя и адрес хоста. 

```
#cloud-config
users:
  - name: ${username}
    groups: sudo
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - ${ssh_public_key}
runcmd:
#  - 'export PUBLIC_IPV4=$(curl ifconfig.me)' #Получение локального IP через внешний сайт
  - 'export PUBLIC_IPV4=$(hostname -I)' #Получение локального IP вручную
  - 'echo Instance name: $(hostname), IP address: $PUBLIC_IPV4 > /var/www/html/index.html'
  - echo '<html><img src="http://${bucket_name}/${image_name}"/></html>' >> /var/www/html/index.html
```

 - Настроить проверку состояния ВМ.

```
  health_check {
    interval = 2
    timeout  = 1
    http_options {
      path = "/"
      port = 80
    }
  }
```

<img width="1022" height="183" alt="изображение" src="https://github.com/user-attachments/assets/fe73a057-cce1-4ce0-b197-ed213d5ae663" />

<img width="1011" height="183" alt="изображение" src="https://github.com/user-attachments/assets/78cc99d3-7e1d-4d47-a79e-c6e4ff6ed26c" />
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.

<img width="1102" height="82" alt="изображение" src="https://github.com/user-attachments/assets/16c7bd17-1a04-4c3b-9e7b-c1c373ed39bf" />

<img width="1249" height="128" alt="изображение" src="https://github.com/user-attachments/assets/db7503fd-920b-4833-af05-5056ac74a50e" />

<img width="679" height="548" alt="изображение" src="https://github.com/user-attachments/assets/41059434-c77f-4d70-a457-daabfcac6e77" />

> Проверяем доступность веб-страницы по адресу балансировщика, 158.160.140.76. 
> Видим что нас подключило на ВМ: Instance name: cl13g2e13nuo90fcnktu-iton, IP address: 192.168.10.14. 

<img width="1805" height="1009" alt="изображение" src="https://github.com/user-attachments/assets/7b9e9f78-6a5f-4788-9b8b-651fc2140df3" />

> Дополнительно в рамках проверки выполним команду curl с рабочего ПК на адрес балансировщика 158.160.140.76. 
> Видим что обращение идёт ко всем ВМ из целевой группы:

<img width="814" height="162" alt="изображение" src="https://github.com/user-attachments/assets/565f1087-7da6-4e25-899a-b671cc7a012e" />
 
 - Проверить работоспособность, удалив одну или несколько ВМ.

> Для проверки остановим ВМ 192.168.10.14, видно как срабатывают проверки и меняется целевая группа.

<img width="1253" height="204" alt="изображение" src="https://github.com/user-attachments/assets/d3494d04-b79c-4692-ac24-30b0224f5327" />

<img width="1003" height="184" alt="изображение" src="https://github.com/user-attachments/assets/71d3de81-0798-429e-819b-38117dcf4b35" />

<img width="1240" height="110" alt="изображение" src="https://github.com/user-attachments/assets/332aa6ac-3a8f-4b12-8978-ea3804960423" />

<img width="669" height="426" alt="изображение" src="https://github.com/user-attachments/assets/913d4e85-8cbe-4e63-9534-3e5c2699a9a7" />

> При проверки веб-страницы картинка доступна, а трафик перераспределяется на оставшиеся две ВМ

<img width="1803" height="1007" alt="изображение" src="https://github.com/user-attachments/assets/99587ba5-5731-4ad1-bc0f-f798d6f6f0ae" />

<img width="833" height="327" alt="изображение" src="https://github.com/user-attachments/assets/eb6d946c-6221-4aef-92e7-b8fe2ae691fc" />

> Дополнительно можно убедиться в корректности проверки состояния ВМ, которая автоматически запустит её после остановки и вернет в целевую группу.

<img width="1013" height="187" alt="изображение" src="https://github.com/user-attachments/assets/5ef7079b-1604-48e4-b532-c8d63f151e64" />

<img width="1329" height="186" alt="изображение" src="https://github.com/user-attachments/assets/fc1a566d-97dc-44c4-b4e6-bf26a98466a2" />

<img width="1234" height="153" alt="изображение" src="https://github.com/user-attachments/assets/23f76be4-cd4f-4526-b251-36ae7128968f" />

<img width="813" height="164" alt="изображение" src="https://github.com/user-attachments/assets/c5dba426-7620-4725-bd16-9bd65bd92175" />


4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

- [alb_target_group.tf](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/22_Project_organization_using_cloud_providers/02_Vychislitelnye_moshchnosti_and_Balansirovshchiki_nagruzki/02_terraform/alb_target_group.tf)
- [alb_backend_group.tf](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/22_Project_organization_using_cloud_providers/02_Vychislitelnye_moshchnosti_and_Balansirovshchiki_nagruzki/02_terraform/alb_backend_group.tf)
- [alb_http_router.tf](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/22_Project_organization_using_cloud_providers/02_Vychislitelnye_moshchnosti_and_Balansirovshchiki_nagruzki/02_terraform/alb_http_router.tf)
- [alb_load_balancer.tf](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/22_Project_organization_using_cloud_providers/02_Vychislitelnye_moshchnosti_and_Balansirovshchiki_nagruzki/02_terraform/alb_load_balancer.tf)

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---
## Задание 2*. AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.

1. Создать бакет S3 и разместить в нём файл с картинкой:

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать доступным из интернета.
2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. 
3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Resource Terraform:

- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template).
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group).
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration).

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```
### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
