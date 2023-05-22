output "subnets_id" {
  description = "List of IDs of the public subnets."
  value       = azurerm_subnet.public[*].id
}

output "db_subnet_id" {
  description = "ID of the DB subnets."
  value       = azurerm_subnet.db[0].id
}

output "vnet_id" {
  description = "ID of the main VNet."
  value       = azurerm_virtual_network.this.id
}