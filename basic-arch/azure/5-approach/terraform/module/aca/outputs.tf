output "ip_address" {
  description = "List of IP address of the environment."
  value       = azurerm_container_app_environment.this.static_ip_address
}

output "products_fqdn" {
  description = "FQDN of the products container."
  value       = azurerm_container_app.products.latest_revision_fqdn
}

output "auth_fqdn" {
  description = "FQDN of the auth container."
  value       = azurerm_container_app.auth.latest_revision_fqdn
}