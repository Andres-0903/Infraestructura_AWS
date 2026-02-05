virginia_cidr = "10.10.0.0/16"
subnets       = ["10.10.0.0/24", "10.10.1.0/24"]
tags = {
  "name"    = "prueba"
  "env"     = "Dev"
  "owner"   = "Andres"
  "Iac"     = "terraform"
  "version" = "1.12.0"
  "cloud"   = "AWS"
  "Project" = "dragon"
  "region"  = "Virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  "ami"           = "ami-0150ccaf51ab55a51"
  "instance_type" = "t2.micro"
}

enable_monitoring = false

ingress_port_list = [22, 80, 443]

# subnets_id = [
#   "subnet-0ff513bd832e532cc",
#   "subnet-088d514840cc19132"
# ]

eks_specs = {
  tipo_instancia = ["t3.small", "t3a.small"] # agrega más si vuelves a SPOT
  ami_type       = "AL2023_x86_64_STANDARD"  # o deja vacío y comenta la línea en el NG
  tipo_capacidad = "ON_DEMAND"               # empieza con OD para descartar capacidad
}

instancias_eks = ["Dev_EKS"] # empieza con 1; agrega más luego si quieres

cluster_name = "Monitoring_Andres"

endpoint_private_access = true

endpoint_public_access = true

kubernetes_version = "1.35"
