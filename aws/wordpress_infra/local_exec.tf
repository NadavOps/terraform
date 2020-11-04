#### waiting for the EKS endpoint to be available
resource "null_resource" "wait_for_cluster" {
  count = var.eks_cluster_endpoint_public_access_enabled ? 1 : 0
  depends_on = [
    aws_eks_cluster.wordpress,
  ]

  provisioner "local-exec" {
    command     = "for i in `seq 1 60`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT/healthz >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      ENDPOINT = aws_eks_cluster.wordpress.endpoint
    }
  }
}

#### update the kubeconfig on the machine running the terraform job
resource "null_resource" "update_kube_config" {
  count = var.eks_cluster_endpoint_public_access_enabled ? 1 : 0
  depends_on = [
    null_resource.wait_for_cluster[0]
  ]

  provisioner "local-exec" {
    command     = <<-EOT
    aws eks update-kubeconfig --name $eks_cluster_name --alias $eks_cluster_name --region $region --profile $profile_name
    kubectl config view --minify --flatten --context=$eks_cluster_name > ~/.kube/config.$eks_cluster_name
    chmod 600 ~/.kube/config.$eks_cluster_name
  EOT
    interpreter = ["/bin/bash", "-c"]
    environment = {
      profile_name     = var.aws_credentials_profile
      region           = var.aws_provider_main_region
      eks_cluster_name = aws_eks_cluster.wordpress.name
    }
  }
}

#### apply aws_auth
resource "null_resource" "apply_yaml_aws_auth" {
  count = var.eks_cluster_endpoint_public_access_enabled ? 1 : 0
  depends_on = [
    null_resource.update_kube_config[0],
    local_file.aws_auth
  ]

  provisioner "local-exec" {
    command     = <<-EOT
    set -ex
    export KUBECONFIG=~/.kube/config.$eks_cluster_name
    kubectl config current-context

    kubectl apply -f $aws_auth_yaml

  EOT
    interpreter = ["/bin/bash", "-c"]
    environment = {
      eks_cluster_name = aws_eks_cluster.wordpress.name
      aws_auth_yaml    = local_file.aws_auth.filename
    }
  }
}