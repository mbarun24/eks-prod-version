resource "aws_eks_node_group" "pathnex-NG" {
  cluster_name    = aws_eks_cluster.pathnex.name
  node_group_name = var.node_group_name

  node_role_arn = aws_iam_role.eks_node.arn

  depends_on = [aws_iam_role_policy_attachment.eks_node]

  subnet_ids     = var.subnet_ids
  version        = var.kubernetes_version
  ami_type       = var.node_ami_type
  capacity_type  = var.node_capacity_type
  instance_types = var.node_instance_types
  disk_size      = var.node_disk_size

  scaling_config {
    desired_size = var.node_scaling.desired_size
    min_size     = var.node_scaling.min_size
    max_size     = var.node_scaling.max_size
  }

  tags = {
    "k8s.io/cluster-autoscaler/enabled"             = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }



  update_config {
    max_unavailable = 1
    update_strategy = "DEFAULT"
  }

  dynamic "remote_access" {
    for_each = var.ssh_key_name == null ? [] : [var.ssh_key_name]
    content {
      ec2_ssh_key               = remote_access.value
      source_security_group_ids = var.ssh_security_group_ids
    }
  }
}
