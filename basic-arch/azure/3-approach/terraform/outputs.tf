output "vm_public_ip" {
  value       = module.lb.lb_public_ip
  description = "The public IP address of the Load Balancer."
}

output "azurerm_postgresql_flexible_server" {
  value = module.db.azurerm_postgresql_flexible_server
}

output "postgresql_flexible_server_database_name" {
  value = module.db.postgresql_flexible_server_database_name
}