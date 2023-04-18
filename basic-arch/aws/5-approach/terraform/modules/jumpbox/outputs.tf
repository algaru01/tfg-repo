output "jumpbox_address" {
  value = aws_instance.jumpbox.associate_public_ip_address
}