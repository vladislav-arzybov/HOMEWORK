#Создаем сервисный аккаунт с необходимыми правами для управления ресурсами кластера k8s
resource "yandex_iam_service_account" "k8s-sa" {
 name        = "k8s-sa"
 description = "Service account for the highly available Kubernetes cluster"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
 # Сервисному аккаунту назначается роль "k8s.clusters.agent".
 folder_id = var.folder_id
 role      = "k8s.clusters.agent"
 member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
 # Сервисному аккаунту назначается роль "vpc.publicAdmin".
 folder_id = var.folder_id
 role      = "vpc.publicAdmin"
 member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.folder_id
 role      = "container-registry.images.puller"
 member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "encrypterDecrypter" {
  # Сервисному аккаунту назначается роль "kms.keys.encrypterDecrypter".
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}
#####Load Balancer role
resource "yandex_resourcemanager_folder_iam_member" "load-balancer" {
  # Сервисному аккаунту назначается роль "load-balancer.admin".
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cluster-api" {
  # Сервисному аккаунту назначается роль "k8s.cluster-api.cluster-admin".
  folder_id = var.folder_id
  role      = "k8s.cluster-api.cluster-admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "alb-editor" {
  # Сервисному аккаунту назначается роль "alb.editor".
  folder_id = var.folder_id
  role      = "alb.editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

######test role
resource "yandex_resourcemanager_folder_iam_member" "certificate-manager" {
  # Сервисному аккаунту назначается роль "certificate-manager.auditor".
  folder_id = var.folder_id
  role      = "certificate-manager.auditor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}
