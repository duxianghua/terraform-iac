module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.27.1"

  cluster_name    = local.eks_cluster_name
  cluster_version = "1.23"

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.eks_cluster_endpoint_access_cidrs

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }


  vpc_id = var.vpc_id

  subnet_ids = concat([for s in aws_subnet.eks-worker-az-a-subnets: s.id], [for s in aws_subnet.eks-worker-az-b-subnets: s.id], [for s in aws_subnet.eks-worker-az-c-subnets: s.id])
  control_plane_subnet_ids = concat([for s in aws_subnet.eks-control-plane-subnets : s.id])


  # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1810
  node_security_group_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = null
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    create_launch_template = true
    launch_template_name   = join("-", [local.eks_cluster_name, "nodegroup-template"])

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 30
          volume_type           = "gp3"
          delete_on_termination = true
        }
      }
    }
    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [module.default-security-group.security_group_id]

    #subnet_ids = ["10.10.0.0/24",10.10.1.0/24", 10.10.2.0/24"]
    # subnet_ids = concat([for s in aws_subnet.eks-private-subnets : s.id])
  }

  eks_managed_node_groups = {
    node_group_01 = {
      name           = "${local.eks_cluster_name}-ng-az-a"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3a.xlarge"]

      labels = {
        "node-group" : "ng-az-a"
      }

      create_iam_role          = true
      iam_role_name            = "${local.eks_cluster_name}-ng-az-a-role"
      iam_role_use_name_prefix = false
      iam_role_description     = "EKS managed node group role"
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]


      create_security_group          = true
      security_group_name            = "${local.eks_cluster_name}-sg-ng-az-a"
      security_group_use_name_prefix = false
      tags                           = local.default_tags
      subnet_ids = concat([for s in aws_subnet.eks-worker-az-a-subnets : s.id])
    }
  }

  # aws-auth configmap
  tags = merge(local.default_tags, {
    "k8s.io/cluster-autoscaler/enabled" : "true"
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" : "owned"
    "nodegroup-role": "worker"
  })
}
