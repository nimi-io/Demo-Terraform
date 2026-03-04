output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = module.eks.cluster_endpoint
}

output "traefik_lb_hostname" {
  description = "AWS NLB hostname for Traefik — point your DNS here"
  value       = try(data.kubernetes_service.traefik.status[0].load_balancer[0].ingress[0].hostname, "pending...")
}

output "service_urls" {
  description = "Service URLs (after DNS is pointed at the NLB)"
  value = {
    grafana    = "https://grafana.${var.domain}"
    prometheus = "https://prometheus.${var.domain}"
    argocd     = "https://argocd.${var.domain}"
    uptime     = "https://uptime.${var.domain}"
  }
}

output "kubeconfig_command" {
  description = "Run this to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${var.cluster_name}"
}
