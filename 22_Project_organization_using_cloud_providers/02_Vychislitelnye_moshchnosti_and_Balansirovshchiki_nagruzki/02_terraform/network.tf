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



