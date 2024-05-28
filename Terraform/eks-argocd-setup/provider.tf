provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
terraform {
  backend "s3" {
    bucket = "terraformstatefilenew "
    key    = "statefile"
    region = "us-east-1"
  }
}

provider "helm" {
  kubernetes {
    config_path = "C:\\Users\\pasup\\.kube\\config"
  }
}
