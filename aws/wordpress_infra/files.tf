## EKS aws-auth yaml file in charge of EKS permissions
resource "local_file" "aws_auth" {
  content  = <<EOT
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
#data: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html

EOT
  filename = "${local.assets_path.k8s_yamls}/tf_generated/${var.environment}.aws_auth.yaml"
}