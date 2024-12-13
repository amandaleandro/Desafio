output "vpc_id" {
  description = "O ID da VPC criada."
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Subnets privadas criadas na VPC."
  value       = module.vpc.private_subnets
}

output "eks_cluster_name" {
  description = "Nome do cluster EKS."
  value       = module.eks.cluster_id
}

output "ecr_repository_url" {
  description = "URL do repositório ECR."
  value       = aws_ecr_repository.helloworld_repo.repository_url
}
