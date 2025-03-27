###Create VM DB main and replica

resource "yandex_compute_instance" "db" {
  for_each    = { for vm in var.each_vm : vm.vm_name => vm }
  name        = "${each.value.vm_name}"
  platform_id = var.vm_resource_platform_id
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.fraction
    
  }
  boot_disk {
    initialize_params {
      image_id = "fd86lfi5hfaorstob34r"
      size     = each.value.disk_volume
    }
  }
  scheduling_policy {
    preemptible = var.vm_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_network_interface_nat   
  }

  metadata = {
    serial-port-enable = var.serial-port
    ssh-keys           = "reivol:${local.ssh-key}"
  }

}