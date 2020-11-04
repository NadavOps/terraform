locals {
  security_groups = {
    eks_control_plane = {
      sg_name        = "EKS control plane",
      sg_description = "Entities allowed to the EKS cluster control plane",
      cidr_block_rule = {
        k8s_private_endpoint = {
          type        = "ingress", from_port = 443, to_port = 443, protocol = "TCP",
          cidr_blocks = [aws_vpc.vpc.cidr_block], description = "Allow all VPC instances reach the K8s API private endpoint"
        }
        outbound = {
          type        = "egress", from_port = 0, to_port = 0, protocol = "-1",
          cidr_blocks = ["0.0.0.0/0"], description = "Outbound all allowed"
        }
      }
    }

    eks_wordpress_node_group = {
      sg_name        = "EKS Wordpress node group",
      sg_description = "EKS Wordpress node group SG assigned via launch template",
      cidr_block_rule = {
        ssh = {
          type        = "ingress", from_port = 22, to_port = 22, protocol = "TCP",
          cidr_blocks = var.allowed_ips, description = "SSH"
        }
        outbound = {
          type        = "egress", from_port = 0, to_port = 0, protocol = "-1",
          cidr_blocks = ["0.0.0.0/0"], description = "Outbound all allowed"
        }
      }
    }

  }
}

module "security_groups" {
  source           = "git@github.com:NadavOps/terraform.git//aws/security_groups"
  for_each         = local.security_groups
  sg_name          = "${var.environment}-${each.value.sg_name}"
  sg_description   = "${var.environment}-${each.value.sg_description}"
  vpc_id           = aws_vpc.vpc.id
  tags             = local.tags
  cidr_block_rules = contains(keys(each.value), "cidr_block_rule") ? each.value.cidr_block_rule : {}
  source_sg_rules  = contains(keys(each.value), "source_sg_rules") ? each.value.source_sg_rules : {}
  self_sg_rules    = contains(keys(each.value), "self_sg_rules") ? each.value.self_sg_rules : {}
}