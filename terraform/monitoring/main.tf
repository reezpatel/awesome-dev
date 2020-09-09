resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    name = "monitoring"
  }
}

module "promotheus" {
  source = "./promotheus"
}

module "grafana" {
  source = "./grafana"
}
