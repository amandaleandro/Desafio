# Provider AWS
provider "aws" {
  region = "us-east-1"
}

# Módulo para criação da VPC
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

# IAM Role para o EKS
module "iam_roles" {
  source = "./iam"

  eks_cluster_role_name = "eks-cluster-role"
  ecr_role_name         = "ecr-push-pull-role"
}

# Módulo para criação do Cluster EKS
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
}
