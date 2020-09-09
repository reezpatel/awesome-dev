resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"
  verify     = false
  version    = "5.6.1"
  atomic     = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
