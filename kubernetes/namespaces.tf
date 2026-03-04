resource "kubernetes_namespace" "traefik" {
  metadata { name = "traefik" }
}

resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }
}

resource "kubernetes_namespace" "tools" {
  metadata { name = "tools" }
}
