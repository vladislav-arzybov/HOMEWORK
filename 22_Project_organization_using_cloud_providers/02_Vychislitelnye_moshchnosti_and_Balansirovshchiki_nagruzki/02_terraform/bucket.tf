# Создание бакета
resource "yandex_storage_bucket" "my-bucket" {
  bucket    = "vladislav-arzybov-bucket"
  folder_id = var.folder_id
  max_size = 1073741824 #1Gb

#доступ на чтение
    anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

#класс хранилища
  default_storage_class = "STANDARD"
}

# Загрузка картинки
resource "yandex_storage_object" "cat-picture" {
  bucket     = yandex_storage_bucket.my-bucket.id
  key        = "cat.jpg" #название в бакете
  source     = "./cat.jpg" #путь к файлу при загрузке
  depends_on = [yandex_storage_bucket.my-bucket]
}
