output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.this.id
}

output "lb_public_ip" {
  value       = azurerm_public_ip.this.ip_address
  description = "The public IP address of the LB instance."
}

output "lb_rule" {
  value = azurerm_lb_rule.this.id
}

output "lb_probe" {
  description = "Id of this Load Balancer probe."
  value = azurerm_lb_probe.this.id
}