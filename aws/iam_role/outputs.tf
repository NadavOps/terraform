output "aws_iam_role" {
  value = aws_iam_role.role
}

output "aws_iam_instance_profile_name" {
  value = aws_iam_instance_profile.profile == [] ? null : aws_iam_instance_profile.profile[0].name
}

output "aws_iam_instance_profile_arn" {
  value = aws_iam_instance_profile.profile == [] ? null : aws_iam_instance_profile.profile[0].arn
}

output "aws_iam_instance_profile_id" {
  value = aws_iam_instance_profile.profile == [] ? null : aws_iam_instance_profile.profile[0].id
}

output "aws_iam_role_policy_attachment_managed" {
  value = aws_iam_role_policy_attachment.managed
}

output "aws_iam_role_policy_attachment_custom" {
  value = aws_iam_role_policy_attachment.custom
}