resource "aws_vpc" "VPC_Virginia" {
  cidr_block = var.virginia_cidr
  tags = {
    "Name" = "VPC_Virginia-${local.sufix}"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.VPC_Virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public_Subnet-${local.sufix}"
  }

  availability_zone = var.az_subnets[0]
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.VPC_Virginia.id
  cidr_block = var.subnets[1]
  tags = {
    "Name" = "Private_Subnet-${local.sufix}"
  }
  availability_zone = var.az_subnets[1]

  depends_on = [
  aws_subnet.public_subnet]
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC_Virginia.id

  tags = {
    Name = "IGW Virginia-${local.sufix}"
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.VPC_Virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "public crt-${local.sufix}"
  }
}

resource "aws_route_table_association" "crt_public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_security_group" "sg_public_instance" {
  name        = "sg_public_instance"
  description = "Allow SSH and all egress traffic"
  vpc_id      = aws_vpc.VPC_Virginia.id

  dynamic "ingress" {
    for_each = var.ingress_port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.sg_ingress_cidr]
    }
  }


  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }


  tags = {
    Name = "PublicInstanceSG-${local.sufix}"
  }
}


# module "my_bucket" {
#   source      = "./modulos/s3"
#   bucket_name = "andresarenas030989"

# }
# output "my_bucket_arn" {
#   value = module.my_bucket.s3_bucket_arn
# }

## Modulo para guardar el terraform state proveedor CloudPosse
# module "terraform_state_backend" {
#   source     = "cloudposse/tfstate-backend/aws"
#   version    = "1.7.0"
#   namespace  = "ejemploUso"
#   stage      = "Env"
#   name       = "terraform"
#   attributes = ["state"]

#   terraform_backend_config_file_path = "."
#   terraform_backend_config_file_name = "backend.tf"

#   force_destroy = false
# }


