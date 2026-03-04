# Traefik — ingress controller deployed via Helm
resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "28.3.0"

  set {
    name  = "ports.web.nodePort"
    value = "30080"
  }

  set {
    name  = "ports.websecure.nodePort"
    value = "30443"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  # Enable the Traefik dashboard
  set {
    name  = "ingressRoute.dashboard.enabled"
    value = "true"
  }

  depends_on = [kind_cluster.local]
}
