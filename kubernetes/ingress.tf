# Ingress rules — routes *.local domains through Traefik with TLS
# Add these to /etc/hosts for local dev:
#   127.0.0.1  grafana.local prometheus.local argocd.local uptime.local metabase.local traefik.local

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"               = "traefik"
      "cert-manager.io/cluster-issuer"            = "selfsigned"
      "traefik.ingress.kubernetes.io/router.tls"  = "true"
    }
  }

  spec {
    tls {
      hosts       = ["grafana.local"]
      secret_name = "grafana-tls"
    }
    rule {
      host = "grafana.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana"
              port { number = 80 }
            }
          }
        }
      }
    }
  }

  depends_on = [null_resource.selfsigned_issuer, helm_release.traefik]
}

resource "kubernetes_ingress_v1" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"    = "traefik"
      "cert-manager.io/cluster-issuer" = "selfsigned"
    }
  }

  spec {
    tls {
      hosts       = ["prometheus.local"]
      secret_name = "prometheus-tls"
    }
    rule {
      host = "prometheus.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-server"
              port { number = 80 }
            }
          }
        }
      }
    }
  }

  depends_on = [null_resource.selfsigned_issuer, helm_release.traefik]
}

resource "kubernetes_ingress_v1" "argocd" {
  metadata {
    name      = "argocd"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"    = "traefik"
      "cert-manager.io/cluster-issuer" = "selfsigned"
    }
  }

  spec {
    tls {
      hosts       = ["argocd.local"]
      secret_name = "argocd-tls"
    }
    rule {
      host = "argocd.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port { number = 80 }
            }
          }
        }
      }
    }
  }

  depends_on = [null_resource.selfsigned_issuer, helm_release.traefik]
}

resource "kubernetes_ingress_v1" "uptime_kuma" {
  metadata {
    name      = "uptime-kuma"
    namespace = kubernetes_namespace.tools.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"    = "traefik"
      "cert-manager.io/cluster-issuer" = "selfsigned"
    }
  }

  spec {
    tls {
      hosts       = ["uptime.local"]
      secret_name = "uptime-kuma-tls"
    }
    rule {
      host = "uptime.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "uptime-kuma"
              port { number = 3001 }
            }
          }
        }
      }
    }
  }

  depends_on = [null_resource.selfsigned_issuer, helm_release.traefik]
}

