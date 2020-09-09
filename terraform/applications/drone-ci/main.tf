resource "kubernetes_config_map" "drone_config_map" {
  metadata {
    name      = "drone-ci"
    namespace = "automation"
  }

  data = {
    "DRONE_SERVER_HOST" = "ci.rlab.app"
    "DRONE_SERVER_PROTO" : "http"
    "DRONE_RPC_SECRET" : var.drone_rpc_secret
    "DRONE_GITHUB_CLIENT_ID" : var.drone_github_client_id
    "DRONE_GITHUB_CLIENT_SECRET" : var.drone_github_client_secret
  }
}

resource "kubernetes_persistent_volume_claim" "drone_pvc" {
  metadata {
    name      = "drone-ci-pvc"
    namespace = "automation"
  }

  spec {
    storage_class_name = "local-path"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }

  wait_until_bound = false
}

resource "kubernetes_deployment" "drone_deployment" {
  metadata {
    name      = "drone-ci"
    namespace = "automation"

    labels = {
      app = "drone-ci"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "drone-ci"
      }
    }

    template {
      metadata {
        labels = {
          app = "drone-ci"
        }
      }

      spec {
        container {
          name              = "server"
          image             = "drone/drone:1.9.0"
          image_pull_policy = "IfNotPresent"

          port {
            name           = "http"
            container_port = 80
            protocol       = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "http"
            }
          }

          env_from {
            config_map_ref {
              name = "drone-ci"
            }
          }

          volume_mount {
            name       = "storage-volume"
            mount_path = "/data"
          }

        }

        node_selector = {
          "node_type" = "services"
        }

        volume {
          name = "storage-volume"
          persistent_volume_claim {
            claim_name = "drone-ci-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "drone_service" {
  metadata {
    name      = "drone-ci"
    namespace = "automation"
  }

  spec {
    selector = {
      app = "drone-ci"
    }

    port {
      port        = 80
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_ingress" "drone_ingress" {
  metadata {
    name      = "drone-ci"
    namespace = "automation"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "ci.rlab.app"
      http {
        path {
          path = "/"
          backend {
            service_name = "drone-ci"
            service_port = 80
          }
        }
      }
    }
  }
}
