variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "demo-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.30"
}

variable "worker_count" {
  description = "Number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "worker_min" {
  description = "Minimum number of worker nodes (autoscaling)"
  type        = number
  default     = 1
}

variable "worker_max" {
  description = "Maximum number of worker nodes (autoscaling)"
  type        = number
  default     = 5
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium" # 2 vCPU, 4GB RAM — ~$0.0416/hr per node
}

variable "domain" {
  description = "Base domain for ingress (must be a Route53 hosted zone you own)"
  type        = string
  default     = "example.com"
}

variable "acme_email" {
  description = "Email for Let's Encrypt certificate registration"
  type        = string
  default     = "admin@example.com"
}
