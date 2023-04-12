output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = module.lb.alb_dns_name
}

output "rds_address" {
  description = "Connect to the database at this endpoint"
  value       = module.db.address
}