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
  default     = "b1gvga9***********"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "folder_id" {
  type        = string
  default     = "b1g51e5***********"
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

