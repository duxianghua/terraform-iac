variable "vpc_id" {
  type        = string
  default     = "vpc-349dc850"
  description = ""
}

variable "private_route_table_id" {
  default = "rtb-0dbc9b7100d74af1f"
}

variable "control_plane_subnets" {
  type    = list(any)
  default = ["10.10.20.0/26", "10.10.20.64/26", "10.10.20.128/26"]
}


variable "eks_worker_az_a_subnets" {
  type    = list(any)
  default = ["10.10.32.0/20", "10.10.48.0/20"]
}

variable "eks_worker_az_b_subnets" {
  type    = list(any)
  default = []
}

variable "eks_worker_az_c_subnets" {
  type    = list(any)
  default = []
}

variable "eks_private_subnets" {
  type    = list(any)
  default = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
}

variable "eks_cluster_endpoint_access_cidrs" {
  type        = list(string)
  description = "the ip cidrs for allow access eks api"
  default     = ["0.0.0.0/0"]
}

variable "kubeconfig_aws_authenticator_command" {
  description = "Command to use to fetch AWS EKS credentials."
  type        = string
  default     = "aws"
}

variable "kubeconfig_aws_authenticator_additional_args" {
  description = "Any additional arguments to pass to the authenticator such as the role to assume. e.g. [\"-r\", \"MyEksRole\"]."
  type        = list(string)
  default     = []
}

variable "kubeconfig_aws_authenticator_env_variables" {
  description = "Environment variables that should be used when executing the authenticator. e.g. { AWS_PROFILE = \"eks\"}."
  type        = map(string)
  default     = {}
}

locals {
  cluster_name = local.eks_cluster_name
  eks_public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                      = 1
  }
  eks_private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"             = 1
  }
  kubeconfig = templatefile("./templates/kubeconfig.tpl", {
    kubeconfig_name                   = local.eks_cluster_name
    endpoint                          = module.eks.cluster_endpoint
    cluster_auth_base64               = module.eks.cluster_certificate_authority_data
    aws_authenticator_command         = var.kubeconfig_aws_authenticator_command
    aws_authenticator_command_args    = ["aws", "eks", "get-token", "--cluster-name", local.cluster_name]
    aws_authenticator_additional_args = var.kubeconfig_aws_authenticator_additional_args
    aws_authenticator_env_variables   = var.kubeconfig_aws_authenticator_env_variables
  })
}