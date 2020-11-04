Defining aws security groups and their rules with the expected opinionated way, \
will allow creation of security groups and rules in one module block.

Example:

Define security groups and rules:

```
locals {
  security_groups = {
    sg_key_1 = {
      sg_name        = "Security group name",
      sg_description = "Security group description",
      cidr_block_rule = {
        rule_key_1 = {
          type        = "ingress", from_port = 22, to_port = 22, protocol = "TCP",
          cidr_blocks = ["0.0.0.0/0"], description = "SSH from everywhere"
        }
      }
      source_sg_rules = {
        rule_key_1 = {
          type                     = "ingress", from_port = 80, to_port = 80, protocol = "TCP",
          source_security_group_id = "source-sg-id", description = "HTTP from specific source sg"
        }
      }
      self_sg_rules = {
        rule_key_1 = {
          type     = "ingress", from_port = 22, to_port = 22,
          protocol = "TCP", description = "Self"
        }
      }
    }
  }
}
```

Call the module:
```
module "security_groups" {
    source           = "git@github.com:NadavOps/terraform.git//aws/security_groups"
    for_each         = local.security_groups
    sg_name          = each.value.sg_name
    sg_description   = each.value.sg_description
    vpc_id           = "vpc-id"
    cidr_block_rules = contains(keys(each.value), "cidr_block_rule") ? each.value.cidr_block_rule : {}
    source_sg_rules  = contains(keys(each.value), "source_sg_rules") ? each.value.source_sg_rules : {}
    self_sg_rules    = contains(keys(each.value), "self_sg_rules") ? each.value.self_sg_rules : {}
}
```