output "sg_object" {
  value = aws_security_group.sg[0]
}

output "sg_arn" {
  value = aws_security_group.sg[0].arn
}

output "sg_id" {
  value = aws_security_group.sg[0].id
}