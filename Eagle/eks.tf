locals {
  # MISMAS subnets para Cluster y Node Groups
  eks_subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.private_subnet.id
  ]
}

resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name # p.ej. "Monitoring_Andres"
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.kubernetes_version # "1.35" (sin .0)

  vpc_config {
    endpoint_private_access = var.endpoint_private_access # true
    endpoint_public_access  = var.endpoint_public_access  # true
    # ⚠️ Deja que EKS maneje sus SGs para evitar bloqueos en 443 durante la validación
    # security_group_ids = [aws_security_group.sg_public_instance.id]
    subnet_ids = local.eks_subnet_ids
  }

  tags = { Name = "my_cluster-${local.sufix}" }
}


resource "aws_eks_node_group" "eks_node_group" {
  for_each = var.instancias_eks # p.ej. ["Dev_EKS"] mientras validas

  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "ng-${each.value}"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  # RECOMENDADO: Nodos en PRIVADA cuando ya tienes NAT; para validar puedes usar ambas:
  subnet_ids = [
    aws_subnet.private_subnet.id
  ]

  ami_type       = var.eks_specs.ami_type
  instance_types = var.eks_specs.tipo_instancia
  capacity_type  = var.eks_specs.tipo_capacidad # "ON_DEMAND" para validar, luego SPOT

  scaling_config {
    min_size     = 1
    desired_size = 1
    max_size     = 2
  }

  update_config { max_unavailable = 1 }

  labels = { ng = each.value }
  tags   = { Name = "eks-${each.value}", Owner = "Gio" }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController
  ]
}
