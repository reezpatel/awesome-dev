resource "kubernetes_namespace" "drone_ci_namespace" {
  metadata {
    annotations = {
      name = "drone-ci-runner"
    }

    name = "drone-ci-runner"
  }
}

resource "kubernetes_config_map" "drone_runner_config_map" {
  metadata {
    name      = "drone-runner"
    namespace = "automation"
  }

  data = {
    "DRONE_RPC_HOST" = "drone-ci"
    "DRONE_RPC_PROTO" : "http"
    "DRONE_NAMESPACE_DEFAULT" : "drone-ci-runner"
    "DRONE_RPC_SECRET" : var.drone_rpc_secret
  }
}

resource "kubernetes_service_account" "drone_runner_service_account" {
  metadata {
    name      = "drone-runner"
    namespace = "automation"
  }
}

resource "kubernetes_role" "drone_runner_role" {
  metadata {
    name      = "drone-runner"
    namespace = "drone-ci-runner"

    labels = {
      app = "drone-runner"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log"]
    verbs      = ["get", "create", "delete", "list", "watch", "update"]
  }
}

resource "kubernetes_role_binding" "drone_runner_drone_runner_role" {
  metadata {
    name      = "drone-runner"
    namespace = "drone-ci-runner"

    labels = {
      app = "drone-runner"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "drone-runner"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "drone-runner"
    namespace = "automation"
  }
}

resource "kubernetes_deployment" "drone_runner_deployment" {
  metadata {
    name      = "drone-runner"
    namespace = "automation"

    labels = {
      app = "drone-runner"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "drone-runner"
      }
    }

    template {
      metadata {
        labels = {
          app = "drone-runner"
        }
      }

      spec {
        service_account_name             = "drone-runner"
        automount_service_account_token  = true
        termination_grace_period_seconds = 3600

        container {
          name              = "server"
          image             = "drone/drone-runner-kube:1.0.0-beta.4"
          image_pull_policy = "IfNotPresent"

          port {
            name           = "http"
            container_port = 3000
            protocol       = "TCP"
          }

          resources {
            limits {
              cpu    = "100m"
              memory = "128Mi"
            }

            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          env_from {
            config_map_ref {
              name = "drone-runner"
            }
          }
        }

        node_selector = {
          "node_type" = "services"
        }
      }
    }
  }
}

resource "kubernetes_service" "drone_runner_service" {
  metadata {
    name      = "drone-runner"
    namespace = "automation"
  }

  spec {
    selector = {
      app = "drone-runner"
    }

    port {
      port        = 3000
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }

    type = "ClusterIP"
  }
}
