###Создание ВМ через цикл for_each

resource "yandex_compute_instance" "k8s" {
  for_each    = { for vm in var.each_vm : vm.vm_name => vm }
  name        = each.value.vm_name
  hostname    = each.value.vm_hostname
  platform_id = var.platform_id
  zone        = var.zone-a
    resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.fraction

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
    }
  }
  scheduling_policy {
    preemptible = var.vm_scheduling_policy_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = "true"
  }

  metadata = {
    serial-port-enable = var.serial-port
    #ssh-keys           = "${var.user}:${local.ssh-key}" #Подключение через ssh key
    user-data          = data.template_file.cloudinit.rendered #Подключение через cloud-config
  }

}

####################

###Для удобства настройки ресурсов ВМ не стал переносить прееменные в variables.tf

variable "each_vm" {
  type = list(object({
    vm_name     = string
    vm_hostname = string
    cpu         = number
    ram         = number
    disk_volume = number
    fraction    = number
  }))
  default = [
    {
      vm_name     = "master-node-1"
      vm_hostname = "master-node-1"
      cpu         = 2
      ram         = 2
      disk_volume = 20
      fraction    = 20
    },
    {
      vm_name     = "worker-node-1"
      vm_hostname = "worker-node-1"
      cpu         = 2
      ram         = 2
      disk_volume = 20
      fraction    = 20
    },
    {
      vm_name     = "worker-node-2"
      vm_hostname = "worker-node-2"
      cpu         = 2
      ram         = 2
      disk_volume = 20
      fraction    = 20
    }
  ]
}

