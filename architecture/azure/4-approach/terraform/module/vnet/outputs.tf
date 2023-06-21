output "public_subnets" {
  description = "List of IDs of the public subnets."
  value       = azurerm_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of the private subnets."
  value       = azurerm_subnet.private[*].id
}

output "bastion_subnet" {
  description = "Id of the subnet where the Bastion is deployed."
  value       = azurerm_subnet.bastion[0].id
}

output "database_subnet" {
  description = "Id of the subnet where the database is deployed."
  value       = azurerm_subnet.db[0].id
}

output "vnet_id" {
  description = "Id of the VNET."
  value       = azurerm_virtual_network.this.id
}