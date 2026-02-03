data "aws_key_pair" "my_key" {
  key_name = "my_key"
}

data "aws_eks_cluster" "eks1" {
  name = aws_eks_cluster.my_cluster.name
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.my_cluster.name
}

# data "aws_iam_openid_connect_provider" "oidc" {
#   url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
# }


