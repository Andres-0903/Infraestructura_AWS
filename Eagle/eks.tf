###############################
# CLUSTER EKS
###############################
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    # Endpoints del API Server
    endpoint_private_access = var.endpoint_private_access # true
    endpoint_public_access  = var.endpoint_public_access  # true

    # ⚠️ Sugerencia: deja que EKS gestione sus SGs por defecto salvo que sepas exactamente porqué necesitas uno custom.
    # Si decides mantenerlo, asegúrate de NO bloquear 443 entre nodos y control plane.
    # security_group_ids      = [aws_security_group.sg_public_instance.id]

    # Usa las MISMAS subnets para cluster y node groups (evita NodeCreationFailure)
    subnet_ids = var.subnets_id
  }

  tags = {
    Name = "my_cluster-${local.sufix}"
  }
}

###############################
# TAGS OBLIGATORIOS EN SUBNETS
# (Solo si gestionas las subnets aquí. Si son compartidas, puedes omitir y validar por consola/CLI)
###############################
resource "aws_ec2_tag" "subnet_cluster_tag" {
  for_each    = toset(var.subnets_id)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

###############################
# NODE GROUPS (múltiples con for_each)
###############################
resource "aws_eks_node_group" "eks_node_group" {
  for_each = var.instancias_eks # set(string), ej: {"Dev_EKS","Dev_EKS1"}

  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "ng-${each.value}"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  # Usa EXACTAMENTE las mismas subnets del cluster
  subnet_ids = var.subnets_id

  # K8s 1.35 → AL2023 (o comenta esta línea para dejar AMI default compatible)
  ami_type       = var.eks_specs.ami_type       # "AL2023_x86_64_STANDARD"
  instance_types = var.eks_specs.tipo_instancia # list(string) ej: ["t3.small","t3a.small","t3.micro","t3a.micro"]
  capacity_type  = var.eks_specs.tipo_capacidad # "SPOT" | "ON_DEMAND"

  scaling_config {
    min_size     = 1
    desired_size = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    ng = each.value
  }

  tags = {
    Name  = "eks-${each.value}"
    Owner = "Gio"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    aws_ec2_tag.subnet_cluster_tag # asegura tags antes de crear el NG
  ]
}
