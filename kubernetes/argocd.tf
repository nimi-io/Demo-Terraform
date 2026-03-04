resource "kubernetes_namespace" "argocd" {
  metadata { name = "argocd" }
}

# ArgoCD — GitOps continuous delivery for Kubernetes
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.3.4"

  # Run server in insecure mode (no TLS termination at argocd, handled by ingress)
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  # Expose via NodePort for direct local access
  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "server.service.nodePortHttp"
    value = "30081"
  }

  set {
    name  = "server.service.nodePortHttps"
    value = "30444"
  }

  # Skip pre-install hooks (redis secret init) that cause timeouts
  set {
    name  = "configs.secret.createSecret"
    value = "true"
  }

  timeout          = 600  # 10 minutes
  wait             = true
  wait_for_jobs    = false

  depends_on = [kind_cluster.local]
}

