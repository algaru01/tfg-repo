output "subnets_id" {
  description = "List of IDs of the public subnets."
  value       = azurerm_subnet.public[*].id
}