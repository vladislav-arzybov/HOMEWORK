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
