output "db_address" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}
