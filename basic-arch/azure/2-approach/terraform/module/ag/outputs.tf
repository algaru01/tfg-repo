output "backend_address_pool_id" {
  value = azurerm_public_ip.this.ip_address
}

output "ag_public_ip" {
  value       = azurerm_public_ip.this.ip_address
  description = "The public IP address of the LB instance."
}

output "ag_backend_address_pool" {
  description = "Backend Addess Pool that will be linked to the SS"
  value = one(azurerm_application_gateway.this.backend_address_pool)
}