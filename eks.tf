resource "aws_eks_cluster" "practice" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.kubernetes_version

  depends_on = [aws_iam_role_policy_attachment.eks_cluster]

  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids

    endpoint_public_access  = true
    endpoint_private_access = true

    public_access_cidrs = var.public_access_cidrs
  }
  zonal_shift_config {
    enabled = false
  }
}
