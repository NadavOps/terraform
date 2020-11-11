resource "aws_security_group" "sg" {
  count       = var.sg_create_enabled == true ? length(var.security_groups_list) : 0
  name        = var.security_groups_list[count.index][0]
  description = var.security_groups_list[count.index][1]
  vpc_id      = var.vpc_id

  tags = var.tags
}

locals {
  map_sg_name_2_id = { for sg in aws_security_group.sg : sg.name => sg.id }
}

resource "aws_security_group_rule" "assign_rule_to_sg" {
  count             = length(var.simple_rules)
  type              = lookup(var.simple_rules[count.index], "type", null)
  from_port         = lookup(var.simple_rules[count.index], "from_port", null)
  to_port           = lookup(var.simple_rules[count.index], "to_port", null)
  protocol          = lookup(var.simple_rules[count.index], "protocol", null)
  cidr_blocks       = lookup(var.simple_rules[count.index], "cidr_blocks", null)
  description       = lookup(var.simple_rules[count.index], "description", null)
  security_group_id = lookup(local.map_sg_name_2_id, lookup(var.simple_rules[count.index], "sg_name", null), null)
}

resource "aws_security_group_rule" "assign_sg_to_sg" {
  count                    = length(var.source_sg_rules)
  type                     = lookup(var.source_sg_rules[count.index], "type", null)
  from_port                = lookup(var.source_sg_rules[count.index], "from_port", null)
  to_port                  = lookup(var.source_sg_rules[count.index], "to_port", null)
  protocol                 = lookup(var.source_sg_rules[count.index], "protocol", null)
  source_security_group_id = lookup(local.map_sg_name_2_id, lookup(var.source_sg_rules[count.index], "source_sg_name", null), null)
  description              = lookup(var.source_sg_rules[count.index], "description", null)
  security_group_id        = lookup(local.map_sg_name_2_id, lookup(var.source_sg_rules[count.index], "sg_name", null), null)
}