## 声明 IAM Policy
resource "aws_iam_policy" "eks_node_group_policy" {
  name        = join("-", [local.cluster_name, "eks-node-group-policy"])
  description = "node additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:*",
          "s3:*",
          "ses:*",
          "es:*",
          "sqs:*",
          "sns:*",
          "ecr:*",
          "sts:*",
          "secretsmanager:*",
          "dynamodb:*",
          "kafka:*",
          "ssm:*",
          "msk:*",
          "cloudformation:*",
          "elasticloadbalancing:*",
          "wafv2:*",
          "waf-regional:GetWebACL",
          "waf-regional:GetWebACLForResource",
          "waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL",
          "msk:*",
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "ec2:DescribeAvailabilityZones",
          "elasticfilesystem:CreateAccessPoint",
          "elasticfilesystem:DeleteAccessPoint",
          "elasticfilesystem:TagResource"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_policy" "eks_cluster_autoscale_policy" {
  name = join("-", [local.cluster_name, "eks-cluster-autoscale-policy"])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

## 附加IAM Policy到EKS节点组
resource "aws_iam_role_policy_attachment" "additional_cluster_autoscale" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.eks_cluster_autoscale_policy.arn
  role       = each.value.iam_role_name
}

resource "aws_iam_role_policy_attachment" "additional-eks-node-group-policy" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.eks_node_group_policy.arn
  role       = each.value.iam_role_name
}