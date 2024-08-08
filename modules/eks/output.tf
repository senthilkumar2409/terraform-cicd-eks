output "eks_cluster_endpoint" {
 description = "EKS cluster endpoint"
 value = aws_eks_cluster.cluster.endpoint
}

output "eks_cluster_certificate_authority" {
  value = data.aws_eks_cluster.eks.certificate_authority[0].data
}

output "aws_eks_cluster_auth" {
  value = data.aws_eks_cluster_auth.eks.token
}