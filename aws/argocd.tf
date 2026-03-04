resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.3.4"

  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "configs.secret.createSecret"
    value = "true"
  }

  values = [
    <<-EOT
    server:
      resources:
        requests:
          memory: "128Mi"
          cpu: "100m"
        limits:
          memory: "512Mi"
          cpu: "500m"
    EOT
  ]

  timeout       = 600
  wait          = true
  wait_for_jobs = false

  depends_on = [module.eks]
}
