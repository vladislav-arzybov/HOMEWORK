#Вывод полного пути до изображения для проверки корректности переменных
output "image_url" {
  value = "https://${yandex_storage_bucket.my-bucket.bucket_domain_name}/${yandex_storage_object.cat-picture.key}"
  description = "image url"
}
