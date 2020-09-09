resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = "monitoring"
  verify     = false
  version    = "11.14.0"
  atomic = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
