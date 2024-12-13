output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}
