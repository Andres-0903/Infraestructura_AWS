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



