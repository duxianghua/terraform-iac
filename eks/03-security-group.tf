module "default-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  name        = "default-security-group"
  description = "Security group for default"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  //ingress_rules            = ["https-443-tcp"]
  # ingress_with_cidr_blocks = [
  #   {
  #     name = "ssh"
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = "0.0.0.0/0"
  #     description = "Allow all traffic access"
  #   }
  # ]
}