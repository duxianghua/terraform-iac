variable "aws_region" {
  default     = "ap-southeast-1"
  description = "the aws region"
}


variable "environment" {
  type        = string
  description = "business services and infrastructure logic name"
  default     = "staging"
}

variable "tenant" {
  type    = string
  default = "xingba"
}

variable "namespace" {
  type    = string
  default = "devops"
}
