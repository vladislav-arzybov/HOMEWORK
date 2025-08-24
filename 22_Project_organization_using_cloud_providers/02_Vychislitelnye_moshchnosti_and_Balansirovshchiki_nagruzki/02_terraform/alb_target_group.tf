#Создание целевой группы
resource "yandex_alb_target_group" "alb-group" {
  name           = "my-target-group"

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    ip_address   = yandex_compute_instance_group.ig-1.instances.0.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    ip_address   = yandex_compute_instance_group.ig-1.instances.1.network_interface.0.ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    ip_address   = yandex_compute_instance_group.ig-1.instances.2.network_interface.0.ip_address
  }
  depends_on = [ yandex_compute_instance_group.ig-1 ]
}
