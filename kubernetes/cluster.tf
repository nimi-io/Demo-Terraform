resource "kind_cluster" "local" {
  name            = var.cluster_name
  node_image      = "kindest/node:${var.kubernetes_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.sigs.k8s.io/v1alpha4"

    # Control plane node
    node {
      role = "control-plane"

      # Expose ports on the host for ingress
      extra_port_mappings {
        container_port = 80
        host_port      = 9080
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 443
        host_port      = 9443
        protocol       = "TCP"
      }

      # NodePort mappings — required on macOS for direct localhost access
      extra_port_mappings {
        container_port = 30080
        host_port      = 30080 # Traefik HTTP
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 30090
        host_port      = 30090 # Prometheus
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 30030
        host_port      = 30030 # Grafana
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 30081
        host_port      = 30081 # ArgoCD
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 30031
        host_port      = 30031 # Uptime Kuma
        protocol       = "TCP"
      }

      extra_port_mappings {
        container_port = 30032
        host_port      = 30032 # Metabase
        protocol       = "TCP"
      }
    }

    # Worker nodes — count drives how many are created
    dynamic "node" {
      for_each = range(var.worker_count)
      content {
        role = "worker"
      }
    }
  }
}
