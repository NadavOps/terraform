### Required vars
variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type. https://aws.amazon.com/ec2/instance-types/"
  type        = string
}

variable "subnet_id" {
  description = "The subnet in which the ec2 will be populated in"
  type        = string
}

variable "vpc_security_group_ids" {
  ## Security groups by default are not required by amazon, but in this module it will be required.
  description = "A list of security group IDs to associate with the instances"
  type        = list(string)
}

variable "key_name" {
  ## Key name by default is not required by amazon, but in this module it will be required.
  description = "The ssh key that will be assigned to the ec2 instance"
  type        = string
}


### Optional vars
variable "ec2_create_enabled" {
  ## It might be beneficial to have a flag for some cases such as blue/ green deployments
  description = "If true will create the ec2 resorce"
  type        = bool
  default     = true
}

variable "iam_instance_profile" {
  description = "The IAM instance profile assigned with the ec2 instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the ec2 instance"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data to be launched with the instance creation"
  type        = string
  default     = null
}

variable "user_data_variables" {
  description = "Variables to inject to the user data script"
  type        = map(string)
  default     = null
}

variable "root_block_device" {
  description = "Allows to customize the root block device of the instance"
  type        = list(map(string))
  default     = []
}

variable "associate_public_ip_address_enabled" {
  description = "True to associate a public ip"
  type        = bool
  default     = null
}