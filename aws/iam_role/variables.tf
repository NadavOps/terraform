## Required
variable "role_name" {
  description = "The name of the rold"
  type        = string
}

variable "role_description" {
  description = "The description of the rold"
  type        = string
}

variable "trust_relationship_policy" {
  description = "The trust relationship text, the module accept it as file/ templatefile"
  type        = string
}

## Optional
variable "path" {
  description = "AWS logical path to the role"
  type        = string
  default     = "/"
}

variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role"
  type        = number
  default     = 3600
}

variable "create_profile" {
  description = "True to create a role profile (allows ec2 resources to assume the role)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to assign to the role"
  type        = map(string)
  default     = {}
}

variable "aws_managed_policies" {
  description = "Map of aws managed policies"
  type        = map(string)
  default     = {}
}

variable "custom_managed_policies" {
  description = "Map of custome managed policies"
  type        = map(string)
  default     = {}
}