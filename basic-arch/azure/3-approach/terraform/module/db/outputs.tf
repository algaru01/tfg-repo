output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.this.name
}