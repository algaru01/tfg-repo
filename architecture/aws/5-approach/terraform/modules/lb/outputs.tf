output "auth_target_group_arn" {
  description = "ARN of the auth target group."
  value       = aws_lb_target_group.auth.arn
}

output "products_target_group_arn" {
  description = "ARN of the prodcuts target group."
  value       = aws_lb_target_group.products.arn
}

output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "alb_sg" {
  value = aws_security_group.allow_http.id
}