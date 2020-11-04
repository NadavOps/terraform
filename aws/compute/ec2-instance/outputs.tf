output "ec2_instances_tuple_of_objects" {
  value = aws_instance.ec2_instances
}

output "ec2_instances_private_ips" {
  value = {
      for instance in aws_instance.ec2_instances:
      instance.id => instance.private_ip
  }
}