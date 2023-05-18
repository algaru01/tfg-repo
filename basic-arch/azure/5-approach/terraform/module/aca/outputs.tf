output "ip_address" {
  description = "FQDN of the container."
  value = azurerm_container_app_environment.this.static_ip_address
}

output "fqdn" {
  description = "FQDN of the container."
  value = azurerm_container_app.this.latest_revision_fqdn
}