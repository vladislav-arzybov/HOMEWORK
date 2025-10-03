### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя

> Через CLI создаем файл ключа ```authorized_key.json``` сервисного аккаунта ```testssh``` который в лальнейшем будет использоваться для работы с terraform
- yc iam key create --output authorized_key.json --service-account-name testssh

> Добавляем информацию в блок настроек провайдера, чтобы в дальнейшем не вводить каждый раз ```OAuth-token``` для выполнения команд.

```
provider "yandex" {
  service_account_key_file = file("~/.authorized_key.json")
}
```

3. Подготовьте [backend](https://developer.hashicorp.com/terraform/language/backend) для Terraform:  
   а. Рекомендуемый вариант: [S3 bucket](https://ru.hexlet.io/courses/terraform-basics/lessons/remote-state/theory_unit) в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)
4. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.
5. Создайте VPC с подсетями в разных зонах доступности.
6. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
7. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://developer.hashicorp.com/terraform/language/backend) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий, стейт основной конфигурации сохраняется в бакете или Terraform Cloud
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.









Выполним предварительную настройку для создания Object Storage в yc где в дальнейшем будет храниться текущее состояние проекта, файл .tfstate

1) Т.к. создание бакета и запуск проекта нужно выплнять из разных каталогов, то необходимо заранее сохранить ключи access_key и secret_key в .env файл
Для этого используем ресурс local_file, добавляем в блок провайдеров провайдера hashicorp/local

```
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
```

И сохраняем ключи в файл backend_access_keys.env
```
resource "local_file" "backend_keys" {
  content  = <<EOT
AWS_ACCESS_KEY_ID=${yandex_iam_service_account_static_access_key.sa-static-key.access_key}
AWS_SECRET_ACCESS_KEY=${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}
EOT
  filename = "${path.module}/backend_access_keys.env"
}
```

Выпоняем terraform init, plan, apply

Также для проверки корректности содержимое backend_access_keys.env можно сверить с выводом команд:
- terraform output access_key
- terraform output secret_key

<img width="822" height="250" alt="изображение" src="https://github.com/user-attachments/assets/46be7422-899b-4e7d-b4fc-2de4d574a1b3" />


2) Копируем secret.backend.tfvars в каталог из которго будет разворачиваться инфраструктура проекта

Выполняем команду: terraform init -backend-config=secret.backend.tfvars

<img width="832" height="120" alt="изображение" src="https://github.com/user-attachments/assets/ccca2f40-ee76-48b0-951c-71e77ee2688e" />



После запуска проверяем наличие файла в бакете

<img width="924" height="417" alt="изображение" src="https://github.com/user-attachments/assets/cc8c642a-19c9-4fc8-87c5-2ab4a49d03c6" />


Проверяем что локально в файле .terraform/terraform.tfstate присутствует только информация об удаленном хранилище:

<img width="474" height="61" alt="изображение" src="https://github.com/user-attachments/assets/d2b1ce61-1d3a-442c-9739-d5206b55dbb9" />
