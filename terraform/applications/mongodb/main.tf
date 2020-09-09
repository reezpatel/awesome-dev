resource "kubernetes_secret" "mongodb_secret" {
  metadata {
    name      = "mongodb"
    namespace = "database"

    labels = {
      app = "mongodb"
    }
  }

  type = "Opaque"

  data = {
    mongodb-root-password = "${var.mongodb_root_password}"
  }
}

resource "kubernetes_persistent_volume_claim" "mongodb_pvc" {
  metadata {
    name      = "mongodb-pvc"
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


resource "kubernetes_service_account" "mongodb_service_account" {
  metadata {
    name      = "mongodb"
    namespace = "database"

    labels = {
      app = "mongodb"
    }
  }

  secret {
    name = "mongodb"
  }

  automount_service_account_token = true
}

resource "kubernetes_deployment" "mongodb_deployment" {
  metadata {
    name      = "mongodb"
    namespace = "database"

    labels = {
      app = "mongodb"
    }

    annotations = {}
  }

  spec {
    strategy {
      type = "RollingUpdate"
    }

    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
        annotations = {}
      }

      spec {
        service_account_name            = "mongodb"
        automount_service_account_token = true

        security_context {
          fs_group = "1001"
        }

        node_selector = {
          "node_type" = "services"
        }

        container {
          image             = "bitnami/mongodb:4.2.6-debian-10-r23"
          name              = "mongodb"
          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_non_root = true
            run_as_user     = "1001"
          }

          env {
            name = "MONGODB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mongodb"
                key  = "mongodb-root-password"
              }
            }
          }

          env {
            name  = "MONGODB_SYSTEM_LOG_VERBOSITY"
            value = 0
          }

          env {
            name  = "MONGODB_DISABLE_SYSTEM_LOG"
            value = false
          }

          env {
            name  = "MONGODB_ENABLE_IPV6"
            value = "no"
          }

          env {
            name  = "MONGODB_ENABLE_DIRECTORY_PER_DB"
            value = "no"
          }

          port {
            name           = "mongodb"
            container_port = 27017
          }

          liveness_probe {
            exec {
              command = ["mongo", "--eval", "db.adminCommand('ping')"]
            }

            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            exec {
              command = ["mongo", "--eval", "db.adminCommand('ping')"]
            }

            initial_delay_seconds = 5
            period_seconds        = 10
            timeout_seconds       = 5
            success_threshold     = 1
            failure_threshold     = 6
          }

          volume_mount {
            name       = "data"
            mount_path = "/bitnami/mongodb"

          }

          resources {
            requests {
              cpu    = "1"
              memory = "512Mi"
            }
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = "mongodb-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongodb_service" {
  metadata {
    name      = "mongodb"
    namespace = "database"
  }
  spec {
    type = "ClusterIP"

    selector = {
      app = "mongodb"
    }

    port {
      name        = "mongodb"
      port        = 27017
      target_port = "mongodb"
    }
  }
}
