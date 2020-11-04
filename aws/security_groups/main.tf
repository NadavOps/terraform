resource "aws_security_group" "sg" {
  count       = var.sg_create_enabled ? 1 : 0
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = var.sg_name })
}

resource "aws_security_group_rule" "cidr_block_rule" {
  for_each          = var.cidr_block_rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = var.sg_create_enabled ? aws_security_group.sg[0].id : "what should be passed if sg is not created?"
}

resource "aws_security_group_rule" "source_sg_rule" {
  for_each                 = var.source_sg_rules
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
  security_group_id        = var.sg_create_enabled ? aws_security_group.sg[0].id : "what should be passed if sg is not created?"
}

resource "aws_security_group_rule" "self_sg_rule" {
  for_each          = var.self_sg_rules
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  self              = true
  description       = each.value.description
  security_group_id = var.sg_create_enabled ? aws_security_group.sg[0].id : "what should be passed if sg is not created?"
}