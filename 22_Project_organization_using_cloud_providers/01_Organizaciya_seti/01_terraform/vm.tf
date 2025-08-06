###Create VM public
resource "yandex_compute_instance" "vm1" {
  name        = var.vm1_name
  platform_id = var.platform_id #Intel Broadwell
  zone        = var.default_zone
  hostname    = var.vm1_hostname

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
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vm_boot_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = var.network_interface_nat  #public ip
  }

  metadata = {
    serial-port-enable = var.serial-port
    ssh-keys           = "${var.user}:${local.ssh-key}" #ssh key
  }
}

###Create VM private
resource "yandex_compute_instance" "vm2" {
  name        = var.vm2_name
  platform_id = var.platform_id #Intel Broadwell
  zone        = var.private_zone
  hostname    = var.vm2_hostname

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
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vm_boot_disk_size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = var.private_network_interface_nat  #public ip
    security_group_ids = [ yandex_vpc_security_group.private.id ]
  }

  metadata = {
    serial-port-enable = var.serial-port
    ssh-keys           = "${var.user}:${local.ssh-key}" #ssh key
  }
}