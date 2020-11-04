locals {
  eks_cluster = {
    name                        = "${var.environment}-wordpress"
    public_endpoint_allowed_ips = var.allowed_ips
  }

  eks_wordpress_node_group = {
    name = "${var.environment}-wordpress-node-group"
  }
}

#### EKS service (Control Plane) ####
resource "aws_eks_cluster" "wordpress" {
  name     = local.eks_cluster.name
  role_arn = module.k8s_pre_deployment_iam_roles["eks_cluster_role"].aws_iam_role.arn

  ## need to see if the CW log group is created and destroyed automatically? for the logs
  enabled_cluster_log_types = var.eks_cluster_logs_enabled ? ["api", "audit", "authenticator", "controllerManager", "scheduler"] : []
  version                   = var.eks_cluster_version

  vpc_config {
    ## for private access requires more research- making it true with specific ips does not work
    endpoint_private_access = var.eks_cluster_endpoint_private_access_enabled ? true : false
    endpoint_public_access  = var.eks_cluster_endpoint_public_access_enabled ? true : false
    public_access_cidrs     = var.eks_cluster_endpoint_public_access_enabled ? local.eks_cluster.public_endpoint_allowed_ips : []
    security_group_ids      = [module.security_groups["eks_control_plane"].sg_id]
    subnet_ids              = concat(local.subnet_ids.public)
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.eks_cluster_service_ipv4_cidr
  }

  tags = merge(local.tags, { Name = local.eks_cluster.name })

  ## is this required?  
  depends_on = [module.k8s_pre_deployment_iam_roles]
}

#### wordpress EKS node group ####
## wordpress EKS node group launch template
resource "aws_launch_template" "wordpress_eks_node_group" {
  name                   = local.eks_wordpress_node_group.name
  instance_type          = var.wordpress_launch_template_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [module.security_groups["eks_wordpress_node_group"].sg_id, aws_eks_cluster.wordpress.vpc_config[0].cluster_security_group_id]
  user_data              = base64encode(file("${local.assets_path.user_data}/cloud_init.wordpress_node_group.sh"))

  monitoring {
    enabled = var.wordpress_launch_template_enhanced_monitoring_enabled
  }

  block_device_mappings {
    device_name = var.wordpress_launch_template_device_name

    ebs {
      volume_size           = var.wordpress_launch_template_volume_size
      delete_on_termination = var.wordpress_launch_template_delete_on_termination_enabled ? true : false
      encrypted             = var.wordpress_launch_template_encrypted_enabled ? true : false
      volume_type           = var.wordpress_launch_template_volume_type
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.tags, { Name = local.eks_wordpress_node_group.name })
  }
  tag_specifications {
    resource_type = "volume"
    tags          = merge(local.tags, { Name = local.eks_wordpress_node_group.name })
  }

  tags = merge(local.tags, { Name = local.eks_wordpress_node_group.name })
}
## wordpress EKS node group
resource "aws_eks_node_group" "wordpress" {
  cluster_name    = aws_eks_cluster.wordpress.name
  node_group_name = local.eks_wordpress_node_group.name
  node_role_arn   = module.k8s_pre_deployment_iam_roles["eks_wordpress_node_group"].aws_iam_role.arn
  subnet_ids      = concat(local.subnet_ids.public)

  scaling_config {
    min_size     = var.eks_wordpress_node_group_min_instances
    max_size     = var.eks_wordpress_node_group_max_instances
    desired_size = var.eks_wordpress_node_group_desired_instances
  }

  version       = var.eks_wordpress_node_group_k8s_version
  ami_type      = "AL2_x86_64"
  capacity_type = "ON_DEMAND"

  launch_template {
    id      = aws_launch_template.wordpress_eks_node_group.id
    version = aws_launch_template.wordpress_eks_node_group.latest_version
  }

  labels = { Name = local.eks_wordpress_node_group.name }
  tags   = merge(local.tags, { Name = local.eks_wordpress_node_group.name })

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  ## is IAM dependancy required?  
  depends_on = [module.k8s_pre_deployment_iam_roles, null_resource.apply_yaml_aws_auth[0]]
}

#### OIDC provier for EKS ####
data "tls_certificate" "wordpress_eks_cluster" {
  url = aws_eks_cluster.wordpress.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "wordpress" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = sort(data.tls_certificate.wordpress_eks_cluster.certificates[*].sha1_fingerprint)
  url             = aws_eks_cluster.wordpress.identity[0].oidc[0].issuer
}