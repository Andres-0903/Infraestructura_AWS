resource "aws_instance" "my-instance" {
  for_each               = toset(var.instancias)
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("scripts/user_data.sh")

  tags = {
    Name = "${each.value}-${local.sufix}"
  }
}

# #Codigo para generar una instancia de monitoreo
# resource "aws_instance" "monitoring-instance" {
#   count                  = var.enable_monitoring ? 1 : 0
#   ami                    = var.ec2_specs.ami
#   instance_type          = var.ec2_specs.instance_type
#   subnet_id              = aws_subnet.public_subnet.id
#   key_name               = data.aws_key_pair.key.key_name
#   vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
#   user_data              = file("scripts/user_data.sh")

#   tags = {
#     Name = "Monitoreo"
#   }



