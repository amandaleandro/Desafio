resource "aws_security_group" "eks_security_group" {
  name   = "eks-cluster-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description      = "Allow traffic to Kubernetes API"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["<your-office-ip>/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-security-group"
  }
}
