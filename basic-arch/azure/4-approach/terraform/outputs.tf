output "ag_public_ip" {
  value       = module.ag.ag_public_ip
  description = "The public IP address of the AG instance."
}

output "bastion_public_ip_fqdn" {
  value = module.bastion.bastion_public_ip_fqdn
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}