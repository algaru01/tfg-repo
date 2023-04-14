output "vm_public_ip" {
  value       = module.lb.lb_public_ip
  description = "The public IP address of the Load Balancer."
}