###disk create

resource "yandex_compute_disk" "default" {
  count    = var.disk_resource_count
  name     = "${var.disk_resource_name}-${count.index+1}"
  type     = var.disk_resource_type
  size     = var.disk_resource_size
    
}


###VM create


resource "yandex_compute_instance" "storage" {
  name        = var.vm_storage_resource_name
  platform_id = var.vm_resource_platform_id
  resources {
    cores         = var.vms_resources.cores
    memory        = var.vms_resources.memory
    core_fraction = var.vms_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  ##mount disk
  dynamic secondary_disk {
    for_each = yandex_compute_disk.default
    content { 
        disk_id = secondary_disk.value.id 
        }
  }

  scheduling_policy {
    preemptible = var.vm_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_network_interface_nat
    security_group_ids = [ yandex_vpc_security_group.example.id ]
  }

  metadata = {
    serial-port-enable = var.serial-port
    ssh-keys           = "ubuntu:${local.ssh-key}"
  }

}