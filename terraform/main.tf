provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role-${random_id.eks_id.hex}"

  lifecycle {
    prevent_destroy = true  # Impede que o recurso seja destruído
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "eks-cluster-policy-${random_id.eks_id.hex}"
  description = "Policy for EKS cluster role"

  lifecycle {
    prevent_destroy = true  # Impede que o recurso seja destruído
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:DescribeCluster"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "eks_key" {
  description = "KMS key for EKS cluster"

  lifecycle {
    prevent_destroy = true  # Impede que o recurso seja destruído
  }
}

resource "aws_kms_alias" "eks_kms_alias" {
  name          = "alias/eks/my-eks-cluster-${random_id.eks_id.hex}"
  target_key_id = aws_kms_key.eks_key.key_id

  lifecycle {
    prevent_destroy = true  # Impede que o recurso seja destruído
  }
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/my-eks-cluster/cluster-${random_id.eks_id.hex}"
  retention_in_days = 7

  lifecycle {
    prevent_destroy = true  # Impede que o recurso seja destruído
  }
}

resource "random_id" "eks_id" {
  byte_length = 8
}

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

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster-${random_id.eks_id.hex}"
  cluster_version = "1.24"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  node_groups = {
    eks_node_group = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }

  enable_irsa = true
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
  role       = aws_iam_role.eks_cluster_role.name
}

resource "random_id" "eks_id" {
  byte_length = 8
}
