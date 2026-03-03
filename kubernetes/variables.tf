variable "cluster_name" {
  description = "Name of the kind cluster"
  type        = string
  default     = "local-cluster"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "kubernetes_version" {
  description = "Kubernetes version (kind node image tag)"
  type        = string
  default     = "v1.30.0"
}
