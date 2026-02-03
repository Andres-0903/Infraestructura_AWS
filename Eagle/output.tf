output "ec2_public" {
  description = "Ip Publica de la instancia"
  value       = [for instance in aws_instance.my-instance : instance.public_ip]

}
