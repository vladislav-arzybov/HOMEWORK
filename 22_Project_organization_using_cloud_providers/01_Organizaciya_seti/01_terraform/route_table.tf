//
// Create a new VPC Route Table.
//
resource "yandex_vpc_route_table" "prod-rt" {
  network_id = yandex_vpc_network.prod-vpc.id
  name = var.route_table_name

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_network_interface_ip_address
  }

}

