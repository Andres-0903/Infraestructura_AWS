variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
}


variable "subnets" {
  description = "Lista de Subnets"
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

variable "cluster_name" {
  type        = string
  description = "Nombre del cluster EKS"
  default     = "Monitoring_Andres"
}

variable "kubernetes_version" {
  type        = string
  description = "Versión de Kubernetes (ej: 1.35)"
  default     = "1.35" # SIN .0
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enable Private Endpoint"
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable Public Endpoint"
  default     = true
}

variable "eks_specs" {
  description = "Especificaciones instancias EKS"
  type = object({
    tipo_instancia = list(string)
    ami_type       = string
    tipo_capacidad = string
  })
  default = {
    tipo_instancia = ["t3.small", "t3a.small"] # agrega más si vas a SPOT después
    ami_type       = "AL2023_x86_64_STANDARD"
    tipo_capacidad = "ON_DEMAND" # valida OD; luego pasas a SPOT
  }
}

variable "instancias_eks" {
  description = "Nombres lógicos de Node Groups"
  type        = set(string)
  default     = ["Dev_EKS"] # empieza solo con 1 NG para validar rápido
}


variable "az_subnets" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}


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
