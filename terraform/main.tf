# Provider AWS
provider "aws" {
  region = "us-east-1"
}

# Módulo para criação da VPC (somente uma vez, certifique-se de que está sendo chamado apenas aqui)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# Defina as permissões do IAM diretamente, se necessário, para evitar o erro de módulo não encontrado
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Módulo para criação do Cluster EKS (garanta que este módulo não está duplicado)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
}

# Output do Cluster EKS ID
output "eks_cluster_id" {
  description = "The EKS cluster ID"
  value       = module.eks.cluster_id
}

