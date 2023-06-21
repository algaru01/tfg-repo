output "public_subnets" {
  description = "List of IDs of the public subnets."
  value       = azurerm_subnet.public[*].id
}