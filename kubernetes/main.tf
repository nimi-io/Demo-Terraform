terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  config_path = "${path.module}/local-cluster-config"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/local-cluster-config"
  }
}
