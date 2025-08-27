#Ссылка на картинку для проверки прав дотупа
output "image_url" {
  value = "https://${yandex_storage_bucket.my-bucket.bucket_domain_name}/${yandex_storage_object.cat-picture.key}"
  description = "image url"
}
