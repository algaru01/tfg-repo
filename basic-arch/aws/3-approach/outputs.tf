output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = module.lb.alb_dns_name
}