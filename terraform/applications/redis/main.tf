resource "kubernetes_config_map" "redis_config_map" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
    namespace = "database"
  }

  data = {
    "redis.conf"   = file("${path.module}/redis.conf")
    "master.conf"  = file("${path.module}/master.conf")
    "replica.conf" = file("${path.module}/replica.conf")
  }
}

resource "kubernetes_config_map" "redis_health_config_map" {
  metadata {
    name = "redis-health"
    labels = {
      app = "redis"
    }
    namespace = "database"
  }

  data = {
    "ping_readiness_local.sh"            = file("${path.module}/ping_readiness_local.sh")
    "ping_liveness_local.sh"             = file("${path.module}/ping_liveness_local.sh")
    "ping_readiness_master.sh"           = file("${path.module}/ping_readiness_master.sh")
    "ping_readiness_local_and_master.sh" = file("${path.module}/ping_readiness_local_and_master.sh")
    "ping_liveness_local_and_master.sh"  = file("${path.module}/ping_liveness_local_and_master.sh")
  }
}

resource "kubernetes_service" "redis_headless_svc" {
  metadata {
    name = "redis-headless"
    labels = {
      app = "redis"
    }
    namespace = "database"
  }
  spec {
    selector = {
      app = "redis"
    }
    type = "ClusterIP"
    port {
      name        = "redis"
      port        = 6379
      target_port = "redis"
    }

  }
}

resource "kubernetes_stateful_set" "redis_stateful_set" {
  metadata {
    name = "redis-master"
    labels = {
      app = "redis"
    }

    namespace = "database"
  }

  spec {
    selector {
      match_labels = {
        app : "redis"
      }
    }

    service_name = "redis-headless"

    template {
      metadata {
        labels = {
          app  = "redis"
          role = "master"
        }
      }

      spec {

        security_context {
          fs_group = "1001"
        }

        node_selector = {
          "node_type" = "services"
        }

        container {
          name              = "redis"
          image             = "bitnami/redis:5.0.7-debian-10-r32"
          image_pull_policy = "IfNotPresent"

          command = [
            "/bin/bash",
            "-c",
            file("${path.module}/redis_exec.sh")
          ]

          env {
            name  = "REDIS_REPLICATION_MODE"
            value = "master"
          }

          env {
            name  = "ALLOW_EMPTY_PASSWORD"
            value = "yes"
          }

          env {
            name  = "REDIS_PORT"
            value = "6379"
          }

          port {
            name           = "redis"
            container_port = "6379"
          }

          security_context {
            run_as_user = "1001"
          }

          liveness_probe {
            exec {
              command = ["sh", "-c", "/health/ping_liveness_local.sh 5"]
            }

            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 5
          }

          readiness_probe {
            exec {
              command = ["sh", "-c", "/health/ping_readiness_local.sh 1"]
            }

            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 1
            success_threshold     = 1
            failure_threshold     = 5
          }

          resources {
            requests {
              memory = "2Gi"
              cpu    = "1"
            }
          }

          volume_mount {
            name       = "health"
            mount_path = "/health"
          }

          volume_mount {
            name       = "redis-data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "config"
            mount_path = "/opt/bitnami/redis/mounted-etc"
          }
        }

        volume {
          name = "health"
          config_map {
            name         = "redis-health"
            default_mode = "0755"
          }
        }

        volume {
          name = "config"
          config_map {
            name = "redis"

          }
        }

        volume {
          name = "redis-data"
          persistent_volume_claim {
            claim_name = "redis-pvc"
          }
        }

      }
    }

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "redis_pvc" {
  metadata {
    name      = "redis-pvc"
    namespace = "database"
  }

  spec {
    storage_class_name = "local-path"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "15Gi"
      }
    }
  }

  wait_until_bound = false
}

resource "kubernetes_service" "redis_master_svc" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
    namespace = "database"
  }
  spec {
    selector = {
      app = "redis"
    }
    type = "ClusterIP"
    port {
      name        = "redis"
      port        = 6379
      target_port = "redis"
    }

  }
}
