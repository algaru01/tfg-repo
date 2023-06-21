output "lb_address" {
  description = "Address of the load balancer."
  value       = module.lb.lb_address
}

/* output "jumpbox_address" {
  description = "Address of the jumpbox host."
  value       = module.jumpbox.jumpbox_address
} */