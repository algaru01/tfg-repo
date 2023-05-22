output "vms_public_ip" {
  value       = azurerm_linux_virtual_machine.this[*].public_ip_addresses[0]
  description = "The public IP address of the VM instance."
}