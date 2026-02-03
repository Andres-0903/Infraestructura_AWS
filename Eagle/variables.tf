variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
}

# variable "public_subnet" {
#   description = "CIDR Public Subnet"
#   type        = string
# }

# variable "private_subnet" {
#   description = "CIDR Private Subnet"
#   type        = string
# }

variable "subnets" {
  description = "Lista de Subnets"
  type        = list(string)
}

variable "subnets_id" {
  description = "Subnet ID"
  type        = list(string)
}

variable "tags" {
  description = "Tags del proyecto"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type        = string
}

variable "ec2_specs" {
  description = "Parametros de la Instancia"
  type        = map(string)

}
variable "ingress_port_list" {
  description = "lista de puertos"
  type        = list(number)
}

#####variables instancia#####
variable "instancias" {
  description = "Nombre de las instancias"
  type        = set(string)
  default     = ["apache", "Mysql", "Java", "MongoDB"]
}

variable "enable_monitoring" {
  description = "Habilita el despliegue servidor monitoreo"
  type        = bool
}


# Nombre del cluster y versión
variable "cluster_name" {
  type        = string
  description = "Nombre del cluster EKS"
}

variable "kubernetes_version" {
  type        = string
  description = "Versión de Kubernetes (ej: 1.35)"
}

# Endpoints del API Server
variable "endpoint_private_access" {
  type        = bool
  description = "Enable Private Endpoint"
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable Public Endpoint"

}

variable "az_subnets" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


# (Opcional) CIDRs para el endpoint público (si tu módulo lo soporta)
# variable "public_access_cidrs" {
#   type        = list(string)
#   default     = ["TU.IP.PUBLICA/32"] # agrega tu IP si deseas restringir
# }

# Subnets para el cluster y los node groups (2 AZ distintas recomendado)
# variable "subnets_id" {
#   type        = list(string)
#   description = "Subnets del cluster/node groups"
# }

######Referencia instancias EKS######
# Especificaciones del Node Group
variable "eks_specs" {
  description = "Especificaciones instancias EKS"
  type = object({
    tipo_instancia = list(string) # ej: ["t3.small","t3a.small","t3.micro","t3a.micro"]
    ami_type       = string       # ej: "AL2023_x86_64_STANDARD" (o dejar vacío y comentar la línea en el NG)
    tipo_capacidad = string       # "SPOT" o "ON_DEMAND"
  })
}

# Para crear múltiples Node Groups de la misma configuración
variable "instancias_eks" {
  description = "Nombres lógicos de los Node Groups"
  type        = set(string)
  default     = ["Dev_EKS", "Dev_EKS1"]
}

# # Sufijo para tags del cluster
# locals {
#   sufix = "andres03"
# }

###############################
# Variables generales
###############################
variable "project" {
  type    = string
  default = "AWS_EKS"
}

variable "name_service" {
  type    = string
  default = "EKS"
}

variable "purpose" {
  type    = string
  default = "monitoring"
}

variable "environment" {
  type    = string
  default = "Dev"
}
