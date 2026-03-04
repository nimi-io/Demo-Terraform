# Uptime Kuma — service monitoring & status page
resource "kubernetes_deployment" "uptime_kuma" {
  metadata {
    name      = "uptime-kuma"
    namespace = kubernetes_namespace.tools.metadata[0].name
    labels    = { app = "uptime-kuma" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "uptime-kuma" }
    }

    template {
      metadata {
        labels = { app = "uptime-kuma" }
      }

      spec {
        container {
          name  = "uptime-kuma"
          image = "louislam/uptime-kuma:1"

          port {
            container_port = 3001
          }

          volume_mount {
            name       = "data"
            mount_path = "/app/data"
          }
        }

        volume {
          name = "data"
          empty_dir {}
        }
      }
    }
  }

  depends_on = [kind_cluster.local]
}

resource "kubernetes_service" "uptime_kuma" {
  metadata {
    name      = "uptime-kuma"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }

  spec {
    selector = { app = "uptime-kuma" }
    type     = "NodePort"

    port {
      port        = 3001
      target_port = 3001
      node_port   = 30031
    }
  }
}
