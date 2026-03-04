# Metabase — data analytics and BI dashboards
resource "kubernetes_deployment" "metabase" {
  metadata {
    name      = "metabase"
    namespace = kubernetes_namespace.tools.metadata[0].name
    labels    = { app = "metabase" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "metabase" }
    }

    template {
      metadata {
        labels = { app = "metabase" }
      }

      spec {
        container {
          name  = "metabase"
          image = "metabase/metabase:v0.49.2"

          port {
            container_port = 3000
          }

          env {
            name  = "MB_DB_TYPE"
            value = "h2" # built-in H2 DB for local/dev use
          }

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "1Gi"
              cpu    = "500m"
            }
          }
        }
      }
    }
  }

  # Metabase is a heavy JVM app — give it time to start
  timeouts {
    create = "10m"
    update = "10m"
  }

  wait_for_rollout = false

  depends_on = [kind_cluster.local]
}

resource "kubernetes_service" "metabase" {
  metadata {
    name      = "metabase"
    namespace = kubernetes_namespace.tools.metadata[0].name
  }

  spec {
    selector = { app = "metabase" }
    type     = "NodePort"

    port {
      port        = 3000
      target_port = 3000
      node_port   = 30032
    }
  }
}
