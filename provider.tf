terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.51.1"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.31.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
}
provider "aws" {
  # Configuration options
  region = "us-east-1"
  access_key = "AKIA6GBMB57RKLNQTL45"
  secret_key = "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"
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority)
  exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
}
provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

