# Grafana — dashboards and visualization
resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.0.0"

  set {
    name  = "adminUser"
    value = "admin"
  }

  set {
    name  = "adminPassword"
    value = "admin"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "service.nodePort"
    value = "30030"
  }

  # Pre-wire Prometheus as default datasource
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }

  values = [
    <<-EOT
    datasources:
      datasources.yaml:
        apiVersion: 1
        datasources:
          - name: Prometheus
            type: prometheus
            url: http://prometheus-server.monitoring.svc.cluster.local
            access: proxy
            isDefault: true
    EOT
  ]

  depends_on = [helm_release.prometheus]
}
