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

  # Allow dashboard access without auth (local dev only)
  set {
    name  = "api.insecure"
    value = "true"
  }

  # Enable Kubernetes Ingress provider so standard Ingress resources work
  set {
    name  = "providers.kubernetesIngress.enabled"
    value = "true"
  }

  # Enable cert-manager integration via TLS annotations
  set {
    name  = "providers.kubernetesIngress.allowExternalNameServices"
    value = "true"
  }

  depends_on = [kind_cluster.local]

  timeout = 300
}

