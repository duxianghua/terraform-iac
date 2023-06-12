# resource "aws_subnet" "eks-private-subnets" {
#   for_each = { for i, s in var.eks_private_subnets : s => { index = i } }

#   vpc_id                  = var.vpc_id
#   cidr_block              = each.key
#   map_public_ip_on_launch = false
#   availability_zone       = local.aws_azs[each.value.index]

#   tags = merge(
#     local.default_tags,
#     local.eks_private_subnet_tags,
#     {
#       Name = join("-", [local.eks_cluster_name, "private-subnet", local.aws_azs[each.value.index]])
#     }
#   )
# }

# resource "aws_route_table_association" "eks-route-table-private" {
#   for_each = aws_subnet.eks-private-subnets

#   subnet_id      = each.value.id
#   route_table_id = var.private_route_table_id
# }

resource "aws_subnet" "eks-control-plane-subnets" {
  for_each = { for i, s in var.control_plane_subnets : s => { index = i } }

  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  map_public_ip_on_launch = false
  availability_zone       = local.aws_azs[each.value.index]

  tags = merge(
    local.default_tags,
    local.eks_private_subnet_tags,
    {
      Name = join("-", [local.eks_cluster_name, "control-plane-subnet", local.aws_azs[each.value.index]])
    }
  )
}

resource "aws_route_table_association" "eks-control-plane-route-table" {
  for_each = aws_subnet.eks-control-plane-subnets

  subnet_id      = each.value.id
  route_table_id = var.private_route_table_id
}

## 
resource "aws_subnet" "eks-worker-az-a-subnets" {
  for_each = { for i, s in var.eks_worker_az_a_subnets : s => { index = i } }

  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"

  tags = merge(
    local.default_tags,
    local.eks_private_subnet_tags,
    {
      Name = join("-", [local.eks_cluster_name, "worker-subnet", "a", each.value.index])
    }
  )
}

resource "aws_route_table_association" "eks-worker-route-table-az-a" {
  for_each = aws_subnet.eks-worker-az-a-subnets

  subnet_id      = each.value.id
  route_table_id = var.private_route_table_id
}


resource "aws_subnet" "eks-worker-az-b-subnets" {
  for_each = { for i, s in var.eks_worker_az_b_subnets : s => { index = i} }

  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}b"

  tags = merge(
    local.default_tags,
    local.eks_private_subnet_tags,
    {
      Name = join("-", [local.eks_cluster_name, "worker-subnet", "b", each.value.index])
    }
  )
}

resource "aws_route_table_association" "eks-worker-route-table-az-b" {
  for_each = aws_subnet.eks-worker-az-b-subnets

  subnet_id      = each.value.id
  route_table_id = var.private_route_table_id
}

resource "aws_subnet" "eks-worker-az-c-subnets" {
  for_each = { for i, s in var.eks_worker_az_c_subnets : s => { index = i } }

  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}c"

  tags = merge(
    local.default_tags,
    local.eks_private_subnet_tags,
    {
      Name = join("-", [local.eks_cluster_name, "worker-subnet", "c", each.value.index])
    }
  )
}

resource "aws_route_table_association" "eks-worker-route-table-az-c" {
  for_each = aws_subnet.eks-worker-az-c-subnets

  subnet_id      = each.value.id
  route_table_id = var.private_route_table_id
}