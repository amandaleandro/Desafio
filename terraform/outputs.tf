output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
# Output do Cluster EKS ID
output "eks_cluster_id" {
  description = "The EKS cluster ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}
# Output do VPC ID
output "vpc_id" {
  description = "The VPC ID"
  value       = module.vpc.vpc_id
}
