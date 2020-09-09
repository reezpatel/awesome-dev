resource "kubernetes_namespace" "local_path_storage" {
  metadata {
    name = "local-path-storage"
  }
}

resource "kubernetes_service_account" "local_path_provisioner_service_account" {
  depends_on = [
    kubernetes_namespace.local_path_storage
  ]

  metadata {
    name      = "local-path-provisioner-service-account"
    namespace = "local-path-storage"
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "local_path_provisioner_role" {
  depends_on = [
    kubernetes_service_account.local_path_provisioner_service_account
  ]

  metadata {
    name = "local-path-provisioner-role"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["nodes", "persistentvolumeclaims"]
  }

  rule {
    verbs      = ["*"]
    api_groups = [""]
    resources  = ["endpoints", "persistentvolumes", "pods"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
  }
}

resource "kubernetes_cluster_role_binding" "local_path_provisioner_bind" {
  depends_on = [
    kubernetes_cluster_role.local_path_provisioner_role
  ]

  metadata {
    name = "local-path-provisioner-bind"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "local-path-provisioner-service-account"
    namespace = "local-path-storage"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "local-path-provisioner-role"
  }
}


resource "kubernetes_storage_class" "local_path" {
  depends_on = [
    kubernetes_cluster_role_binding.local_path_provisioner_bind
  ]

  metadata {
    name = "local-path"
  }

  storage_provisioner = "rancher.io/local-path"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
}

resource "kubernetes_config_map" "local_path_config" {
  depends_on = [
    kubernetes_storage_class.local_path
  ]

  metadata {
    name      = "local-path-config"
    namespace = "local-path-storage"
  }

  data = {
    "config.json" = file("${path.module}/config.json")
  }
}


resource "kubernetes_deployment" "local_path_provisioner" {
  depends_on = [
    kubernetes_storage_class.local_path
  ]

  metadata {
    name      = "local-path-provisioner"
    namespace = "local-path-storage"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "local-path-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          app = "local-path-provisioner"
        }
      }

      spec {
        volume {
          name = "config-volume"

          config_map {
            name = "local-path-config"
          }
        }

        container {
          name    = "local-path-provisioner"
          image   = "rancher/local-path-provisioner:v0.0.12"
          command = ["local-path-provisioner", "--debug", "start", "--config", "/etc/config/config.json"]

          env {
            name = "POD_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config/"
          }

          image_pull_policy = "IfNotPresent"
        }

        automount_service_account_token = true
        service_account_name            = "local-path-provisioner-service-account"
      }
    }
  }
}

