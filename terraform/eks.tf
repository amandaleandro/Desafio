module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnet_ids        = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
}
