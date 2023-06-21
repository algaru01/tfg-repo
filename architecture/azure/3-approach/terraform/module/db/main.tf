resource "azurerm_private_dns_zone" "this" {
  name                = "this.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                = "dns-vnet-link"
  resource_group_name = var.resource_group_name

  virtual_network_id    = var.vnet_id
  private_dns_zone_name = azurerm_private_dns_zone.this.name
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                = "my-db-flexible-server"
  resource_group_name = var.resource_group_name
  location            = var.location

  delegated_subnet_id = var.database_subnet
  private_dns_zone_id = azurerm_private_dns_zone.this.id


  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768
  version    = "13"

  administrator_login    = var.db_user
  administrator_password = var.db_password
  zone                   = 3

  depends_on = [azurerm_private_dns_zone_virtual_network_link.this]
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = "student"
  server_id = azurerm_postgresql_flexible_server.this.id
}