aws_region         = "ap-southeast-2"
cluster_name       = "Practice-2026"
kubernetes_version = "1.36"
subnet_ids = [
  "subnet-0cd8063842a7c3418",
  "subnet-0b376c62065178503",
  "subnet-0188f1ea29c7853d2"
]
security_group_ids     = ["sg-07455d06c80bd1794"]
ssh_key_name           = "production-2026"
ssh_security_group_ids = ["sg-07455d06c80bd1794"]

# Preserve existing IAM names. Omit these overrides for a new cluster.
cluster_role_name      = "AmazonEKSClusterRole"
node_role_name         = "AmazonEKSNodeRole"
ebs_csi_role_name      = "practice-AmazonEKSPodIdentityAmazonEBSCSIDriverRole"
autoscaler_role_name   = "practice-ClusterAutoscalerRole"
autoscaler_policy_name = "practice-ClusterAutoscalerPolicy"

