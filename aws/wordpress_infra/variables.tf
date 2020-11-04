variable "aws_provider_main_region" {
  description = "Region of deployment"
  type        = string
}

variable "aws_credentials_profile" {
  description = "Profile name with the credentials to run. profiles usually are found at ~/.aws/credentials"
  type        = string
}

variable "environment" {
  description = "Identifier to the environment. for example: Dev/ Staging/ Production"
  type        = string
}

variable "ssh_key_name" {
  description = "The default SSH key name, must be already exist in the region of deployment"
  type        = string
}

variable "allowed_ips" {
  description = "Allowed IPs to AWS services and instances"
  type        = list(string)
  default     = []
}

## EKS (AWS K8s)
variable "eks_cluster_version" {
  description = "The control plane version"
  type        = string
  default     = "1.21"
}

variable "eks_cluster_logs_enabled" {
  description = "true will enable logs, false will disable"
  type        = bool
  default     = true
}

variable "eks_cluster_endpoint_private_access_enabled" {
  description = "true enables access to the kubernetes control plane private endpoint"
  type        = bool
  default     = true
}

variable "eks_cluster_endpoint_public_access_enabled" {
  description = "true enables access to the kubernetes control plane public endpoint"
  type        = bool
  default     = false
}

variable "eks_cluster_service_ipv4_cidr" {
  description = "The control plane CIDR"
  type        = string
  default     = "192.168.0.0/16"
}

## EKS Wordpress Node Group
variable "wordpress_launch_template_instance_type" {
  description = "The Wordpress node group instance type"
  type        = string
  default     = "m5a.large"
}

variable "wordpress_launch_template_enhanced_monitoring_enabled" {
  description = "true enables enhanced monitoring for wordpress eks node group"
  type        = bool
  default     = true
}

variable "eks_wordpress_node_group_k8s_version" {
  description = "Wordpress node group k8s version"
  type        = string
  default     = "1.21"
}

variable "wordpress_launch_template_device_name" {
  description = "The Wordpress root device name"
  type        = string
  default     = "/dev/xvda"
}

variable "wordpress_launch_template_volume_size" {
  description = "The Wordpress root device volume size"
  type        = number
  default     = 50
}

variable "wordpress_launch_template_delete_on_termination_enabled" {
  description = "true deletes root block device on termination"
  type        = bool
  default     = true
}

variable "wordpress_launch_template_encrypted_enabled" {
  description = "true encrypts root block device at rest"
  type        = bool
  default     = true
}

variable "wordpress_launch_template_volume_type" {
  description = "The root block EBS type"
  type        = string
  default     = "gp3"
}

variable "eks_wordpress_node_group_desired_instances" {
  description = "Wordpress desired instances"
  type        = number
  default     = 2
}

variable "eks_wordpress_node_group_min_instances" {
  description = "Wordpress minimum instances"
  type        = number
  default     = 2
}

variable "eks_wordpress_node_group_max_instances" {
  description = "Wordpress maximum instances"
  type        = number
  default     = 6
}