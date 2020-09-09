resource "kubernetes_namespace" "nginx_namespace" {
  metadata {
    annotations = {
      name = "ingress-system"
    }

    name = "ingress-system"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "ingress-system"
  verify     = false
  version    = "0.6.0"

  values = [
    file("${path.module}/values.yaml")
  ]
}
