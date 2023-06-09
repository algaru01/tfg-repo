output "username" {
  description = "Username of this registry."
  value       = azurerm_container_registry.this.admin_username
}

output "password" {
  description = "Password of this registry."
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}

output "login_server" {
  description = "Login server of this registry."
  value       = azurerm_container_registry.this.login_server
}