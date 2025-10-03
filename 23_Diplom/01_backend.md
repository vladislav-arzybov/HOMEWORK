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

2) Копируем backend_access_keys.env в каталог из которго будет разворачиваться инфраструктура проекта

Проверить содержимое переменных:
- echo $AWS_ACCESS_KEY_ID
- echo $AWS_SECRET_ACCESS_KEY
