
resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name                = "MySQL-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.prod-vpc.id
  version             = "8.0"
  security_group_ids  = [ yandex_vpc_security_group.mysql-sg.id ] #security_group опционально
  deletion_protection = "true"

  resources {
    resource_preset_id = "b1.medium" #Класс хоста
    disk_type_id       = "network-hdd"
    disk_size          = "20"
  }

  host {
    zone             = "ru-central1-a"
    subnet_id        = yandex_vpc_subnet.private-a.id
    name             = "db-1"
    assign_public_ip = "true" #разрешить_публичный_доступ_к_хосту
    priority         = "100" #приоритет_при_выборе_хоста-мастера
    backup_priority  = "100" #приоритет_для_резервного_копирования
  }
  host {
    zone             = "ru-central1-b"
    subnet_id        = yandex_vpc_subnet.private-b.id
    name             = "db-2"
    assign_public_ip = "true"
    priority         = "10"
    backup_priority  = "10"
  }


  backup_window_start {  #время начала резервного копирования
    hours   = "23"
    minutes = "59"
  }

  maintenance_window {  #время технического обслуживания
    type = "ANYTIME"
  }

}
#DataBase
resource "yandex_mdb_mysql_database" "mysql" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_db"
}
#User
resource "yandex_mdb_mysql_user" "user1" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "reivol"
  password   = "1qaz@WSX" #or generate_password
  #generate_password = true #сгенерировать password
  permission {
    database_name = yandex_mdb_mysql_database.mysql.name
    roles         = ["ALL"]
  }
}

#группa безопасности, порт для подключения
resource "yandex_vpc_security_group" "mysql-sg" {
  name       = "mysql-sg"
  network_id = yandex_vpc_network.prod-vpc.id

  ingress {
    description    = "MySQL®"
    port           = 3306
    protocol       = "TCP"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}
