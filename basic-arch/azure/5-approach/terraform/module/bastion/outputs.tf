output "bastion_public_ip" {
  value = azurerm_public_ip.this.ip_address
}