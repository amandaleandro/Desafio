variable "region" {
  description = "A região AWS onde os recursos serão criados."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "O CIDR da VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Subnets públicas na VPC."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Subnets privadas na VPC."
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_name" {
  description = "Nome do cluster EKS."
  default     = "eks-cluster"
}

variable "desired_capacity" {
  description = "Número desejado de nós."
  default     = 2
}

variable "max_capacity" {
  description = "Número máximo de nós."
  default     = 3
}

variable "min_capacity" {
  description = "Número mínimo de nós."
  default     = 1
}

variable "instance_type" {
  description = "Tipo de instância EC2 para os nós do EKS."
  default     = "t3.medium"
}
