output "jumpbox_address" {
  value = aws_instance.jumpbox.public_ip
}