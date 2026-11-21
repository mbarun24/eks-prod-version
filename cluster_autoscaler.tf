resource "helm_release" "cluster_autoscaler" {
  name             = "cluster-autoscaler"
  namespace        = "cluster-autoscaler"
  create_namespace = true

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  values = [
    yamlencode({
      autoDiscovery = {
        clusterName = aws_eks_cluster.practice.name
      }

      awsRegion     = var.aws_region
      cloudProvider = "aws"

      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
        }
      }
    })
  ]

  depends_on = [
    aws_eks_node_group.practice-NG,
    aws_eks_pod_identity_association.cluster_autoscaler
  ]
}
