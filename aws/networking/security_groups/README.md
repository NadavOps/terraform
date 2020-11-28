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
      sg_rules = {
        rule_key_1 = {
          type        = "ingress", from_port = 22, to_port = 22, protocol = "TCP",
          cidr_blocks = ["0.0.0.0/0"], description = "SSH from everywhere", self = false
        }
      }
    }
  }
}
```

Call the module:
```
module "security_groups" {
    source           = "git@github.com:NadavOps/terraform.git//aws/networking/security_groups"
    for_each         = local.security_groups
    sg_name          = each.value.sg_name
    sg_description   = each.value.sg_description
    vpc_id           = "vpc-id"
    cidr_block_rules = contains(keys(each.value), "sg_rules") ? each.value.sg_rules : {}
}
```