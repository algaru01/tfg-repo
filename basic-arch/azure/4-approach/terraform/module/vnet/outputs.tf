output "subnets_id" {
  description = "List of IDs of the public subnets."
  value       = azurerm_subnet.public[*].id
}

output "bastion_subnet_id" {
  description  = "Id of the subnet where this Bastion is deployed."
  value        = azurerm_subnet.bastionSubnet[0].id
}