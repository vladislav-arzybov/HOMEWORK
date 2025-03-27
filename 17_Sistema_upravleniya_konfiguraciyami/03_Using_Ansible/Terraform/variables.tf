###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default     = "b1gvga9kieio1fe5p4ss"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g51e5v9mh6c4gtt2he"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

###network vars

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}


###resource vars

variable "vm_web_resource_count" {
  type        = number
  default     = 2
  description = "Count VM web"
}

variable "vm_web_resource_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Resource name VM web"
}

variable "vm_db_resource_name" {
  type        = string
  default     = "netology-develop-platform"
  description = "Resource name VM db"
}


variable "vm_storage_resource_name" {
  type        = string
  default     = "netology-develop-platform-storage"
  description = "Resource name VM storage"
}

variable "vm_resource_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "The type of virtual machine to create"
}


###data vars

variable "vm_data_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "The name of the image family to which this image belongs"
}


#scheduling_policy vars

variable "vm_scheduling_policy_preemptible" {
  type        = bool
  default     = true
  description = "Specifies if the instance is preemptible"
}


###resources map vars

variable "vms_resources" {
  type    = map
  default = {
  cores=2
  memory=2
  core_fraction=5
  }
}

###metadata map vars

locals {
  ssh-key = file("~/.ssh/id_ed25519.pub")
}


variable "serial-port" {
  type        = number
  default     = 1
  description = "ssh-keygen console"
}

###network_interface vars

variable "vm_network_interface_nat" {
  type        = bool
  default     = true
  description = "To access the internet over NAT"
}


###for_each vars VM 3 & 4

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
    fraction    = number
  }))
  default = [
    {
      vm_name     = "clickhouse"
      cpu         = 2
      ram         = 4
      disk_volume = 10
      fraction    = 5
    },
    {
      vm_name     = "vector"
      cpu         = 2
      ram         = 4
      disk_volume = 10
      fraction    = 5
    },
    {
      vm_name     = "lighthouse"
      cpu         = 2
      ram         = 2
      disk_volume = 10
      fraction    = 5
    }
  ]
}

###resource disk vars
variable "disk_resource_count" {
  type        = number
  default     = 3
  description = "Count disk"
}

variable "disk_resource_name" {
  type        = string
  default     = "disk"
  description = "Name of the disk"
}

variable "disk_resource_type" {
  type        = string
  default     = "network-hdd"
  description = "Type of disk to create"
}

variable "disk_resource_size" {
  type        = number
  default     = 1
  description = "Size of the persistent disk, specified in GB"
}