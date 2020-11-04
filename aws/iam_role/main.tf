resource "aws_iam_role" "role" {
  name                  = var.role_name
  description           = var.role_description
  force_detach_policies = var.force_detach_policies
  assume_role_policy    = var.trust_relationship_policy
  path                  = var.path
  max_session_duration  = var.max_session_duration

  tags = var.tags
}

resource "aws_iam_instance_profile" "profile" {
  count = var.create_profile ? 1 : 0
  name  = aws_iam_role.role.name
  role  = aws_iam_role.role.name
  path  = var.path
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = var.aws_managed_policies
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each   = var.custom_managed_policies
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy${var.path}${each.value}"
}