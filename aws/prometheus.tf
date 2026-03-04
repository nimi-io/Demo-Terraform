resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.21.0"

  set {
    name  = "server.service.type"
    value = "ClusterIP" # Not exposed directly — accessed via Traefik ingress
  }

  set {
    name  = "alertmanager.enabled"
    value = "false"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "server.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "500m"
  }

  timeout = 600

  depends_on = [module.eks]
}
