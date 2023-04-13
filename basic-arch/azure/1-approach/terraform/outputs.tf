output "vm_public_ip" {
  value       = module.vm.vm_public_ip
  description = "The public IP address of the VM instance."
}