locals {
  assets_path = {
    iam       = "./assets/iam"
    user_data = "./assets/user_data_scripts"
    k8s_yamls = "./assets/k8s_yamls"
  }

  tags = {
    Name             = "${var.environment}-ChangeTag"
    DeploymentMethod = "Terraform"
    Environment      = var.environment
  }
}