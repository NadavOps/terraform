output "ec2_object" {
  value = aws_instance.ec2_instance[0]
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance[0].public_ip
}

output "ec2_private_ip" {
  value = aws_instance.ec2_instance[0].private_ip
}

output "ec2_tags" {
  value = aws_instance.ec2_instance[0].tags
}