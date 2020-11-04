locals {
  iam_policies = {
  }

  k8s_pre_deployment_iam_roles = {
    eks_cluster_role = {
      name               = "eks_cluster_role"
      description        = "K8s cluster IAM role"
      assume_role_policy = file("${local.assets_path.iam}/trust_relationship.eks.json")
      create_profile     = false
      attach_policies = {
        managed = {
          "AmazonEKSClusterPolicy"         = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
          "AmazonEKSVPCResourceController" = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
        }
      }
    }
    eks_wordpress_node_group = {
      name               = "eks_wordpress_node_group"
      description        = "wordpress EKS node group"
      assume_role_policy = file("${local.assets_path.iam}/trust_relationship.ec2.json")
      create_profile     = true
      attach_policies = {
        managed = {
          "AmazonEKSWorkerNodePolicy"          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"          ## required by every node group
          "AmazonEKS_CNI_Policy"               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"               ## required by every node group
          "AmazonEC2ContainerRegistryReadOnly" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" ## required by every node group
        }
        custom = {
        }
      }
    }
  }

}

resource "aws_iam_policy" "policy" {
  for_each    = local.iam_policies
  name        = each.value.name
  description = each.value.description
  policy      = each.value.policy
}

module "k8s_pre_deployment_iam_roles" {
  source                    = "git@github.com:NadavOps/terraform.git//aws/iam_role"
  for_each                  = local.k8s_pre_deployment_iam_roles
  role_name                 = "${var.environment}-${each.value.name}"
  role_description          = "${var.environment}-${each.value.description}"
  force_detach_policies     = true
  create_profile            = each.value.create_profile
  trust_relationship_policy = each.value.assume_role_policy
  path                      = "/"
  tags                      = local.tags

  aws_managed_policies    = contains(keys(each.value.attach_policies), "managed") ? each.value.attach_policies.managed : {}
  custom_managed_policies = contains(keys(each.value.attach_policies), "custom") ? each.value.attach_policies.custom : {}

  depends_on = [aws_iam_policy.policy]
}