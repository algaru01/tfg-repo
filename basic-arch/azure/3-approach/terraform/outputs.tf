output "ag_public_ip" {
  value       = module.ag.ag_public_ip
  description = "The public IP address of the Load Balancer."
}