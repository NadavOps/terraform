### Required vars
variable "security_groups_list" {
  # example [ ["sg1", "description1"], ["sg2", "description2"]]
  description = "A list of security groups names and descriptions, controls the amount of groups to be created"
  type        = list(list(string))
}

variable "vpc_id" {
  description = "The VPC ID in which the security group will be created"
  type        = string
}

### Optional vars
variable "simple_rules" {
  # example: 
  # { type = "ingress/egress", from_port = 1, to_port = 1, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"],
  # description = "", sg_name = "name_from => security_groups_list" }
  description = "A list of rule maps"
  type        = list(any)
  default     = []
}

variable "source_sg_rules" {
  # example: 
  # { type = "ingress/egress", from_port = 1, to_port = 1, protocol = "tcp", description = "",
  # source_sg_name = "name_from => security_groups_list", sg_name = "name_from => security_groups_list" }
  description = "A list of rule maps, assigning security group as the source"
  type        = list(map(string))
  default     = []
}

variable "sg_create_enabled" {
  description = "true by default to enable security groups creation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the ec2 instance"
  type        = map(string)
  default     = {}
}