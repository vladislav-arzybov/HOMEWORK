#Создание группы бэкендов
resource "yandex_alb_backend_group" "backend-group" {
  name                     = "backend-balancer"
  session_affinity {
    connection {
      source_ip = true
    }
  }

  http_backend {
    name                   = "http-backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_alb_target_group.alb-group.id]
    load_balancing_config {
      panic_threshold      = 50
      mode                 = "ROUND_ROBIN"
    }    
    healthcheck {
      timeout              = "1s"
      interval             = "1s"
      healthy_threshold    = 2
      unhealthy_threshold  = 2 
      http_healthcheck {
        path               = "/"
      }
    }
  }
depends_on = [ yandex_alb_target_group.alb-group ]
}