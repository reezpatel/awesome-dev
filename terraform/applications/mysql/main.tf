resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql"
    namespace = "database"

    labels = {
      app = "mysql"
    }
  }

  type = "Opaque"

  data = {
    mysql-root-password = "${var.mysql_root_password}"
  }
}

resource "kubernetes_persistent_volume_claim" "mysql_pvc" {
  metadata {
    name      = "mysql-pvc"
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

resource "kubernetes_deployment" "mysql_deployment" {
  metadata {
    name      = "mysql"
    namespace = "database"

    labels = {
      app = "mysql"
    }

    annotations = {}
  }

  spec {
    strategy {
      type = "Recreate"
    }

    replicas = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
        annotations = {}
      }

      spec {
        init_container {
          name              = "remove-lost-found"
          image             = "busybox:1.32"
          image_pull_policy = "Always"
          command           = ["rm", "-fr", "/var/lib/mysql/lost+found"]

          resources {
            requests {
              memory = "10Mi"
              cpu    = "10m"
            }
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/mysql"
          }
        }

        node_selector = {
          "node_type" = "services"
        }

        container {
          image             = "mysql:5.7.30"
          name              = "mysql"
          image_pull_policy = "IfNotPresent"

          resources {
            requests {
              cpu    = "200m"
              memory = "256Mi"
            }
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mysql"
                key  = "mysql-root-password"
              }
            }
          }

          port {
            name           = "mysql"
            container_port = 3306
          }

          liveness_probe {
            exec {
              command = ["sh", "-c", "mysqladmin ping -u root -p$${MYSQL_ROOT_PASSWORD}"]
            }

            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = ["sh", "-c", "mysqladmin ping -u root -p$${MYSQL_ROOT_PASSWORD}"]
            }

            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 3
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/mysql"

          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = "mysql-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql_service" {
  metadata {
    name      = "mysql"
    namespace = "database"
  }
  spec {
    type = "ClusterIP"

    selector = {
      app = "mysql"
    }

    port {
      name        = "mysql"
      port        = 3306
      target_port = "mysql"
    }
  }
}
