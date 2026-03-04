# Prometheus — metrics collection
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.21.0"

  # Expose via NodePort for local access at http://localhost:30090
  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.service.nodePort"
    value = "30090"
  }

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  depends_on = [kind_cluster.local]
}
