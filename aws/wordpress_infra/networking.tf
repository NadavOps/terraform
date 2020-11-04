locals {
  vpc_cidr_block = {
    dev = "172.16.0.0/16"
  }
  subnet_tags = {
    ## K8s subnet tagging is explained here https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.1/deploy/subnet_discovery/
    k8s_public = tomap({ "kubernetes.io/role/elb" = 1, "kubernetes.io/cluster/${local.eks_cluster.name}" = "shared" })
  }

  subnet_ids = {
    public = [for subnet in aws_subnet.public : subnet.id]
  }
}

## VPC
resource "aws_vpc" "vpc" {
  cidr_block           = lookup(local.vpc_cidr_block, var.environment, local.vpc_cidr_block.dev)
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, { Name = var.environment })
}

## IG (internet gateway)
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.tags, { Name = var.environment })
}

#### Public Networking ####
## Subnets
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  for_each = {
    for index in range(0, length(data.aws_availability_zones.available.zone_ids)) : index => cidrsubnet(aws_vpc.vpc.cidr_block, 3, index)
  }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone_id    = element(data.aws_availability_zones.available.zone_ids, each.key)
  map_public_ip_on_launch = true

  tags = merge(local.tags, local.subnet_tags.k8s_public, { Name = "${var.environment}-public-${each.key}" })
}

## Route tables and routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.tags, { Name = "${var.environment}-public" })
}

resource "aws_route" "public_default_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}