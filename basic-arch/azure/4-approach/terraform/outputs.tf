output "vm_public_ip" {
  value       = module.lb.ss_public_ip
  description = "The public IP address of the VM instance."
}

output "bastion_public_ip_fqdn" {
   value = module.bastion.bastion_public_ip_fqdn
}

output "bastion_public_ip" {
   value = module.bastion.bastion_public_ip
}