variable "sg_create_enabled" {
  description = "true by default to enable security groups creation"
  type        = bool
  default     = true
}

variable "sg_name" {
  description = "The security group name, required if sg_create_enabled is true"
  type        = string
  default     = null
}

variable "sg_description" {
  description = "The security group description, required if sg_create_enabled is true"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID in which the security group will be created, required if sg_create_enabled is true"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the security group"
  type        = map(string)
  default     = {}
}

variable "cidr_block_rules" {
  description = "Map of cidrblock rules"
  type = map(
    object(
      {
        type        = string, from_port = number, to_port = number, protocol = string,
        cidr_blocks = list(string), description = string
      }
    )
  )
  default = {}
}

variable "source_sg_rules" {
  description = "Map of source security groups rules"
  type = map(
    object(
      {
        type                     = string, from_port = number, to_port = number, protocol = string,
        source_security_group_id = string, description = string
      }
    )
  )
  default = {}
}

variable "self_sg_rules" {
  description = "Map of source security groups rules"
  type = map(
    object(
      {
        type     = string, from_port = number, to_port = number,
        protocol = string, description = string
      }
    )
  )
  default = {}
}