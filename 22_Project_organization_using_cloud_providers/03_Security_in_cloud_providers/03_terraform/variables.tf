#Ручной запуск для првоерки прав
/*
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
*/

###cloud vars
variable "cloud_id" {
  type        = string
  default     = "b1gvga9*************"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "folder_id" {
  type        = string
  default     = "b1g51e5*************"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

###network vars
variable "vpc_name" {
  type        = string
  default     = "prod-vpc"
  description = "VPC network name"
}

variable "subnet_public_name" {
  type        = string
  default     = "public"
  description = "subnet name"
}
variable "subnet_private_name" {
  type        = string
  default     = "private"
  description = "subnet name"
}

variable "route_table_name" {
  type        = string
  default     = "prod-rt"
  description = "route table name"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "private_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "username" {
  type        = string
  default     = "ubuntu"
  description = "ssh autorization"
}
locals {
  ssh-key = file("~/.ssh/id_rsa.pub")
}

variable "serial-port" {
  type        = number
  default     = 1
  description = "ssh-keygen console"
}

/*
###data vars
variable "vm_data_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "The name of the image family to which this image belongs"
}


###NAT vars
variable "nat_name" {
  type        = string
  default     = "nat"
  description = "The name of virtual machine to create"
}
variable "platform_id" {
  type        = string
  default     = "standard-v1"
  description = "The type of virtual machine to create"
}
variable "nat_hostname" {
  type        = string
  default     = "nat"
  description = "The hostnae of virtual machine to create"
}

variable "resource_cores" {
  type        = number
  default     = 2
  description = "Count cores"
}
variable "resource_memory" {
  type        = number
  default     = 1
  description = "Count RAM"
}
variable "resource_core_fraction" {
  type        = number
  default     = 5
  description = "Percent CPU used"
}

variable "vm_scheduling_policy_preemptible" {
  type        = bool
  default     = true
  description = "Specifies if the instance is preemptible"
}

variable "nat_boot_disk_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "Image boot disk nat"
}
variable "nat_boot_disk_size" {
  type        = number
  default     = 3
  description = "Gb size HDD"
}

variable "nat_network_interface_ip_address" {
  type        = string
  default     = "192.168.10.254"
  description = "Local ip nat"
}
variable "network_interface_nat" {
  type        = bool
  default     = true
  description = "Public ip address create"
}





##VM vars public
variable "vm1_name" {
  type        = string
  default     = "public"
  description = "The name of virtual machine to create"
}
variable "vm1_hostname" {
  type        = string
  default     = "public"
  description = "The hostnae of virtual machine to create"
}
variable "vm_boot_disk_size" {
  type        = number
  default     = 10
  description = "Gb size HDD"
}

##VM vars private
variable "vm2_name" {
  type        = string
  default     = "private"
  description = "The name of virtual machine to create"
}
variable "vm2_hostname" {
  type        = string
  default     = "private"
  description = "The hostnae of virtual machine to create"
}
variable "private_network_interface_nat" {
  type        = bool
  default     = false
  description = "Public ip address create"
}

*/
