terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.8.4"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = var.default_zone 
}

###s3

terraform {
  required_version = "1.8.4"

  backend "s3" {
    
    region="ru-central1"

    bucket     = "reivol" #FIO-netology-tfstate
    key = "terraform.tfstate"
    

    # access_key                  = "..."          #Только для примера! Не хардкодим секретные данные!
    # secret_key                  = "..."          #Только для примера! Не хардкодим секретные данные!


    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  endpoints ={
    dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gvga9kieio1fe5p4ss/etn20qucqm5k01se6epf"
    s3 = "https://storage.yandexcloud.net"
  }

    dynamodb_table              = "table722"
  }

}