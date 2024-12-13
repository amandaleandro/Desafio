resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_policy" "eks_cluster_policy" {
  name        = "eks-cluster-policy"
  description = "Policy granting necessary permissions to EKS cluster"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*",
          "ec2:CreateSecurityGroup",
          "ec2:ModifyInstanceAttribute",
          "ec2:DescribeInstances",
          "ec2:AuthorizeSecurityGroupIngress"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
}
