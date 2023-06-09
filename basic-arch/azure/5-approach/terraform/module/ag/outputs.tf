output "ag_public_ip" {
  value       = azurerm_public_ip.this.ip_address
  description = "The public IP address of the LB instance."
}

output "ag_port" {
  description = "Port of the fronted of the AG."
  value       = azurerm_application_gateway.this.frontend_port
}

output "ag_backend_address_pool" {
  description = "Backend Addess Pool that will be linked to the SS"
  value       = one(azurerm_application_gateway.this.backend_address_pool)
}