### Required vars
variable "cidr_block" {
  description = "CIDR block, for example 192.168.0.0/24"
  type        = string
}


### Optional vars
variable "instance_tenancy" {
  description = "The default tenancy of instances launched in the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "True enables DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "True enables DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to the VPC resource"
  type        = map(string)
  default     = {}
}