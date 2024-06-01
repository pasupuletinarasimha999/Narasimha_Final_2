variable "cluster-name" {
  description = "Enter eks cluster name - example like eks-demo, eks-dev etc"
  type        = string
  default     = "eks-demo"
}
variable "db_username" {
  type        = string
  default     = "postgres"
}
variable "db_password" {
  type        = string
  default     = "Paster813"
}
