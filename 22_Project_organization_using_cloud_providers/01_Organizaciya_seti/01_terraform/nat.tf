###Create VM nat
resource "yandex_compute_instance" "nat" {
  name        = var.nat_name
  platform_id = var.platform_id #Intel Broadwell
  zone        = var.default_zone
  hostname    = var.nat_hostname

  resources {
    cores  = var.resource_cores
    memory = var.resource_memory
    core_fraction = var.resource_core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_scheduling_policy_preemptible  #prerivaemai
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_boot_disk_image_id #nat
      size     = var.nat_boot_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = var.nat_network_interface_ip_address
    nat       = var.network_interface_nat  #public ip
  }

  metadata = {
    serial-port-enable = var.serial-port
    ssh-keys           = "${var.user}:${local.ssh-key}" #ssh key
  }
}

