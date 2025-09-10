//
// Create a new Managed Kubernetes Node Group.
//
resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = yandex_kubernetes_cluster.my_cluster.id
  name        = "test-group"
  description = "group of nodes for k8s-HA-cluster"
  version     = "1.32"

#  labels = {
#    "key" = "value"
#  }

  instance_template {
    platform_id = "standard-v3" #Intel Ice Lake

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.public-a.id}" ] #Перечень подсетей, при автоматическом масштабировании доступно только одно расположение!  
#      security_group_ids = [yandex_vpc_security_group.ha-k8s-sg.id] #Группа безопасности как у кластера
    }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = true #прерываемая
    }

    container_runtime {
      type = "containerd"
    }
  }
#Политика масштабирования для группы узлов с автоматическим масштабированием
  scale_policy {
    auto_scale {
      initial = 3 #Начальное количество экземпляров в группе узлов
      min = 3
      max = 6
    }
  }
#Перечень подсетей, при автоматическом масштабировании доступно только одно расположение! 
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true #группа узлов может обновляться автоматически
    auto_repair  = true #группа узлов может быть восстановлена ​​автоматически

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}