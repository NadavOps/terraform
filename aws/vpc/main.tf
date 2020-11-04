## VPC (virtual private network) ##
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.tags
}

## IG (internet gateway) ##
resource "aws_internet_gateway" "internet_gateway" {
  count  = var.public_vpc == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags   = var.tags
}

## Default route
resource "aws_route" "defualt_route" {
  count                  = var.public_vpc == true ? 1 : 0
  route_table_id         = aws_vpc.vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

## Get available AZs
data "aws_availability_zones" "available_azs" {
  state = "available"
}

## Subnets
resource "aws_subnet" "main" {
  count                   = length(data.aws_availability_zones.available_azs.zone_ids) > 0 ? length(data.aws_availability_zones.available_azs.zone_ids) : 0
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone_id    = element(sort(data.aws_availability_zones.available_azs.zone_ids), count.index)
  map_public_ip_on_launch = true

  tags = {
    Name     = "Should change it to somthine smarter"
    CretedBy = "Terrafomr"
    Action   = "delete_this"
  }
}
