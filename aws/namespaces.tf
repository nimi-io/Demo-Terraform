resource "kubernetes_namespace" "traefik" {
  metadata { name = "traefik" }

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "tools" {
  metadata { name = "tools" }

  depends_on = [module.eks]
}

resource "kubernetes_namespace" "argocd" {
  metadata { name = "argocd" }

  depends_on = [module.eks]
}
