variable "cluster2_name" {
  description = "Enter eks cluster name - example like eks-demo, eks-dev etc"
  type        = string
  default     = "cluster2"
}
variable "cluster_name" {
  description = "Enter eks cluster name - example like eks-demo, eks-dev etc"
  type        = string
  default     = "eks-demo"
}
variable "db_username" {
  type    = string
  default = "postgres"
}
variable "db_password" {
  type    = string
  default = "Paster813"
}
variable "region-name" {
  description = "Region in AWS"
  type        = string
  default     = "us-east-1"
}
variable "region_name" {
  description = "Region in AWS"
  type        = string
  default     = "us-east-1"
}
variable "route53-zoneid" {
  description = "route53 in AWS"
  type        = string
  default     = "Z094518528U0CKC6X69LA"
}


variable "cluster_version" {
  type    = string
  default = "1.30"
}
variable "cluster2_version" {
  type    = string
  default = "1.30"
}
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_account_id" {
  description = "account id number"
  default     = "471112577330"
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default     = "us-east-1"
}

variable "external_dns_chart_version" {
  description = "External-dns Helm chart version to deploy. 3.0.0 is the minimum version for this function"
  type        = string
  default     = "6.14.3"
}

variable "external_dns_chart_log_level" {
  description = "External-dns Helm chart log leve. Possible values are: panic, debug, info, warn, error, fatal"
  type        = string
  default     = "warn"
}

variable "external_dns_zoneType" {
  description = "External-dns Helm chart AWS DNS zone type (public, private or empty for both)"
  type        = string
  default     = "public"
}

variable "external_dns_domain_filters" {
  description = "External-dns Domain filters."
  type        = list(string)
  default     = ["www.krazyworks.shop"]
}

variable "github_username" {
  description = "used to integrate argocd to github"
  type        = string
  default     = "pasupuletinarasimha999"
}
variable "github_token" {
  description = "used to integrate argocd to github"
  type        = string
  default     = "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"
  sensitive   = true
}