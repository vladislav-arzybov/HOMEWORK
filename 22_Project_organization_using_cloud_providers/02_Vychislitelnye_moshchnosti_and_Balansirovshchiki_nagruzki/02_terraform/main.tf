#Объявляем новые переменные для cloud-init.yml
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

    vars = {
    username           = var.username
    ssh_public_key     = file("~/.ssh/id_rsa.pub")
    bucket_name        = yandex_storage_bucket.my-bucket.bucket_domain_name
    image_name         = yandex_storage_object.cat-picture.key

  }

}
