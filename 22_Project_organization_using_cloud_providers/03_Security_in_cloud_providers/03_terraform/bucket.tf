resource "yandex_iam_service_account" "sa" {
  name = "storage-user"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "storage-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

#Назначение роли для шифрования и расшифрования файлов при загрузке
resource "yandex_resourcemanager_folder_iam_member" "storage-kms-admin" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}


# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

# Создание kms ключа
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "kms-key-storage"
  description       = "kms for storage"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" // 1 год
}

# Создание бакета
resource "yandex_storage_bucket" "my-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "vladislav-arzybov-bucket"
  folder_id  = var.folder_id
  max_size   = 1073741824 #1Gb
  default_storage_class = "STANDARD"

#параметры шифрования
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Загрузка картинки
resource "yandex_storage_object" "cat-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.my-bucket.id
  key        = "cat.jpg" #название в бакете
  source     = "./cat.jpg" #путь к файлу при загрузке
}



#url ---  https://storage.yandexcloud.net/vladislav-arzybov-bucket/cat.jpg