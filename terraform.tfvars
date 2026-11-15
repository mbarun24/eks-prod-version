aws_region         = "ap-south-1"
cluster_name       = "Pathnex-nov-2026"
kubernetes_version = "1.36"
subnet_ids = [
  "subnet-0c8e402019bf39260",
  "subnet-036e80f1443e50c12",
  "subnet-06fe4b0251c95b8a1"
]
security_group_ids     = ["sg-0d257e9dec69dbffd"]
ssh_key_name           = "Pathnex.pem"
ssh_security_group_ids = ["sg-0d257e9dec69dbffd"]

# Preserve existing IAM names. Omit these overrides for a new cluster.
cluster_role_name      = "AmazonEKSClusterRole"
node_role_name         = "AmazonEKSNodeRole"
ebs_csi_role_name      = "pathnex-AmazonEKSPodIdentityAmazonEBSCSIDriverRole"
autoscaler_role_name   = "pathnex-ClusterAutoscalerRole"
autoscaler_policy_name = "pathnex-ClusterAutoscalerPolicy"
