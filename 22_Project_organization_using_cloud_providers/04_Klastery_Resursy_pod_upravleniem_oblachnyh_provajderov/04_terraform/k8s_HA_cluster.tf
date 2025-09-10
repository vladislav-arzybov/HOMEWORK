resource "yandex_kubernetes_cluster" "my_cluster" {
  name = "k8s-cluster"
  network_id = yandex_vpc_network.prod-vpc.id
  master {
    regional {
      region = "ru-central1"
    location {
      zone      = yandex_vpc_subnet.public-a.zone
      subnet_id = yandex_vpc_subnet.public-a.id
    }
    location {
      zone      = yandex_vpc_subnet.public-b.zone
      subnet_id = yandex_vpc_subnet.public-b.id
    }
    location {
      zone      = yandex_vpc_subnet.public-d.zone
      subnet_id = yandex_vpc_subnet.public-d.id
    }
  }
    security_group_ids = [yandex_vpc_security_group.ha-k8s-sg.id] #Группа безопасности

    version   = "1.32"
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

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
  service_account_id      = yandex_iam_service_account.k8s-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.encrypterDecrypter,
    yandex_resourcemanager_folder_iam_member.load-balancer,
    yandex_resourcemanager_folder_iam_member.cluster-api,
    yandex_resourcemanager_folder_iam_member.alb-editor,
    yandex_resourcemanager_folder_iam_member.certificate-manager
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }

  release_channel         = "STABLE"
  network_policy_provider = "CALICO"
}

# Ключ Yandex Key Management Service для шифрования информации.
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "kms-key"
  description       = "key for k8s"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}
