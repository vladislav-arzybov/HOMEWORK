output "network_id" {

    value = yandex_vpc_network.develop.id
}

output "subnet_id" {

    value = yandex_vpc_subnet.develop.id
}

output "security_id" {

    value = yandex_vpc_security_group.example.id
}

