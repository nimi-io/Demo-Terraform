output "cluster_name" {
  description = "Name of the kind cluster"
  value       = kind_cluster.local.name
}

output "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  value       = kind_cluster.local.kubeconfig_path
}

output "endpoint" {
  description = "Kubernetes API endpoint"
  value       = kind_cluster.local.endpoint
}
