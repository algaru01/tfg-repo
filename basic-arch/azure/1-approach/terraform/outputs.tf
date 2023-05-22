output "vms_public_ip" {
  value       = module.vm.vms_public_ip
  description = "The public IP address of the VM instance."
}