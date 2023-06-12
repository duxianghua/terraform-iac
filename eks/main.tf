terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  aws_region = "us-east-1"
  eks_cluster_name = "eks-demo-01"
  default_tags = {
    Tenant      = var.tenant
    Terraform   = 1
    Environment = var.environment
  }
  cost_tags = {
    environment = "prod"
    product     = "devops"
    department  = "application"
    owner       = "admin"
  }
  aws_azs  = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_name = "StagingVPC2"
}
