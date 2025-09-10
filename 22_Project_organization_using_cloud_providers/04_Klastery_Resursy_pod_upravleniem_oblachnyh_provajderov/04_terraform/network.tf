###network

resource "yandex_vpc_network" "prod-vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_public_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = var.public_cidr

}
resource "yandex_vpc_subnet" "private" {
  name           = var.subnet_private_name
  zone           = var.private_zone
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = var.private_cidr
}

#Новые подсети для кластера MySQL
resource "yandex_vpc_subnet" "private-a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.21.0/24"]
}
resource "yandex_vpc_subnet" "private-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.22.0/24"]
}


#Новые подсети для кластера K8S
resource "yandex_vpc_subnet" "public-a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}
resource "yandex_vpc_subnet" "public-b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}
resource "yandex_vpc_subnet" "public-d" {
  name           = "public-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.prod-vpc.id
  v4_cidr_blocks = ["192.168.13.0/24"]
}
