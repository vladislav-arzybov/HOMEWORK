#L7 load_balancer
resource "yandex_alb_load_balancer" "my_alb" {
  name        = "my-load-balancer"
  network_id  = yandex_vpc_network.prod-vpc.id

#Размещение, зоны доступности и подсети
  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

#Обработчик
  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    
    #Прием и обработка трафика, HTTP
    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }

 depends_on = [ yandex_alb_http_router.http-router ] 
}
