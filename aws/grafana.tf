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
    value = "admin" # Change this for real deployments
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  values = [
    <<-EOT
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "250m"
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

  timeout = 600

  depends_on = [helm_release.prometheus]
}
