# Домашнее задание к занятию «Безопасность в облачных провайдерах»  - `Арзыбов Владислав`

Используя конфигурации, выполненные в рамках предыдущих домашних заданий, нужно добавить возможность шифрования бакета.

---
## Задание 1. Yandex Cloud   

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:

[код Terraform](https://github.com/vladislav-arzybov/HOMEWORK/blob/main/22_Project_organization_using_cloud_providers/03_Security_in_cloud_providers/03_terraform/bucket.tf)

 - создать ключ в KMS;

<img width="1137" height="225" alt="изображение" src="https://github.com/user-attachments/assets/74cf3f6f-6101-43ac-b282-e6efe6538ca5" />
 
 - с помощью ключа зашифровать содержимое бакета, созданного ранее.

> Т.к. данные шифруются лишь в процессе загрузки повторно создадим бакет и загрузим в него картинку, как видно ключ шифрования на месте:

<img width="955" height="356" alt="изображение" src="https://github.com/user-attachments/assets/e1dbb978-4a61-420f-a7d6-ffb1334da374" />

<img width="1031" height="403" alt="изображение" src="https://github.com/user-attachments/assets/5c905961-68c2-4ab2-ad77-c94b5baeea7b" />

> Проверяем доступность изображения по ссылке, доступ запрещен: https://vladislav-arzybov-bucket.storage.yandexcloud.net/cat.jpg

<img width="776" height="210" alt="изображение" src="https://github.com/user-attachments/assets/a6d5a2fd-24a3-439f-a2b4-5b3cce08411e" />

> Через UI можно получить ссылку лишь на определенное время

<img width="564" height="144" alt="изображение" src="https://github.com/user-attachments/assets/1e614bd0-0224-4dfa-a7c1-86edb6dd22bf" />


2. (Выполняется не в Terraform)* Создать статический сайт в Object Storage c собственным публичным адресом и сделать доступным по HTTPS:

 - создать сертификат;
 - создать статическую страницу в Object Storage и применить сертификат HTTPS;
 - в качестве результата предоставить скриншот на страницу с сертификатом в заголовке (замочек).

Полезные документы:

- [Настройка HTTPS статичного сайта](https://cloud.yandex.ru/docs/storage/operations/hosting/certificate).
- [Object Storage bucket](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket).
- [KMS key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key).

--- 
## Задание 2*. AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. С помощью роли IAM записать файлы ЕС2 в S3-бакет:
 - создать роль в IAM для возможности записи в S3 бакет;
 - применить роль к ЕС2-инстансу;
 - с помощью bootstrap-скрипта записать в бакет файл веб-страницы.
2. Организация шифрования содержимого S3-бакета:

 - используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к созданному ранее бакету S3 возможность шифрования Server-Side, используя общий ключ;
 - включить шифрование SSE-S3 бакету S3 для шифрования всех вновь добавляемых объектов в этот бакет.

3. *Создание сертификата SSL и применение его к ALB:

 - создать сертификат с подтверждением по email;
 - сделать запись в Route53 на собственный поддомен, указав адрес LB;
 - применить к HTTPS-запросам на LB созданный ранее сертификат.

Resource Terraform:

- [IAM Role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role).
- [AWS KMS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key).
- [S3 encrypt with KMS key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object#encrypting-with-kms-key).

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
aws s3 mb s3://mysuperbacketname2021
aws s3 cp index.html s3://mysuperbacketname2021
```

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
