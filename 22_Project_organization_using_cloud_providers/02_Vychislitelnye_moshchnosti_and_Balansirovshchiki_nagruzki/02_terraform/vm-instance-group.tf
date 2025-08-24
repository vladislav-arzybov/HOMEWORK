#Группа виртуальных машин фиксированного размера с сетевым балансировщиком нагрузки

#Создаем сервисный аккаунт с необходимыми правами
resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "Сервисный аккаунт для управления группой ВМ."
}

resource "yandex_resourcemanager_folder_iam_member" "compute-editor" {
  folder_id = var.folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"

  depends_on = [ yandex_iam_service_account.ig-sa ] # зависимость для корректной выдачи прав
}

resource "yandex_resourcemanager_folder_iam_member" "load-balancer-editor" {
  folder_id = var.folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"

  depends_on = [ yandex_iam_service_account.ig-sa ] # зависимость для корректной выдачи прав
}

#Роль для L7 балансировщика, Application Load Balancer
resource "yandex_resourcemanager_folder_iam_member" "alb-editor" {
  folder_id = var.folder_id
  role      = "alb.editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig-sa.id}"

  depends_on = [ yandex_iam_service_account.ig-sa ] # зависимость для корректной выдачи прав  
}

#Создаем группу ВМ
resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig-with-balancer"
  folder_id           = var.folder_id
  service_account_id  = yandex_iam_service_account.ig-sa.id
  deletion_protection = false
  depends_on = [ yandex_resourcemanager_folder_iam_member.compute-editor, yandex_resourcemanager_folder_iam_member.load-balancer-editor, yandex_resourcemanager_folder_iam_member.alb-editor ] # зависимость для корректного создания и удаления ВМ
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit" #LAMP
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.prod-vpc.id
      subnet_ids         = [ yandex_vpc_subnet.public.id ]
    }

    metadata = {
      serial-port-enable = var.serial-port
      #ssh-keys           = "${var.username}:${local.ssh-key}" #Подключение через ssh key
      user-data          = data.template_file.cloudinit.rendered #Подключение через cloud-config
    }
  }

#Группа ВМ фиксированная или масштабируемая
  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [ var.default_zone ]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

#Проверка состояний ВМ
  health_check {
    interval = 2
    timeout  = 1
    http_options {
      path = "/"
      port = 80
    }
  }


#Добавляем ВМ в nlb-load_balancer
  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}