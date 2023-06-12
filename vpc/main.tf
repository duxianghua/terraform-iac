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
  aws_azs  = ["${var.aws_region}a"]
  vpc_name = "${var.environment}-${var.namespace}-vpc"
}
