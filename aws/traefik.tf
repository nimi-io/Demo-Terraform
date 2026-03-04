# Traefik — ingress controller
# On AWS, uses a LoadBalancer service which provisions an AWS NLB automatically
resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = kubernetes_namespace.traefik.metadata[0].name
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "28.3.0"

  # AWS: use LoadBalancer (provisions an NLB) instead of NodePort
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }

  # Enable dashboard (protected in production — fine for demo)
  set {
    name  = "ingressRoute.dashboard.enabled"
    value = "true"
  }

  set {
    name  = "api.insecure"
    value = "true"
  }

  set {
    name  = "providers.kubernetesIngress.enabled"
    value = "true"
  }

  timeout = 300

  depends_on = [module.eks]
}

# Fetch the NLB hostname assigned to Traefik after it's created
data "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  depends_on = [helm_release.traefik]
}
