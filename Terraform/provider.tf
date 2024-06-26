provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

terraform {
  backend "s3" {
    bucket         = "narasimhapriya"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "helm" {
  kubernetes {
    config_path            = "~/.kube/config"
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
provider "kubernetes" {
  alias = "eks_demo"
  config_path = "~/.kube/config"
  config_context = "arn:aws:eks:us-east-1:471112577330:cluster/eks-demo"
}
provider "kubernetes" {
  alias = "cluster2"
  config_path = "~/.kube/config"
  config_context = "arn:aws:eks:us-east-1:471112577330:cluster/cluster2"
}

provider "kubectl" {
  alias                   = "cluster1"
  host                    = module.eks.cluster_endpoint
  cluster_ca_certificate  = base64decode(module.eks.cluster_certificate_authority_data)
  token                   = data.aws_eks_cluster_auth.cluster.token
}
