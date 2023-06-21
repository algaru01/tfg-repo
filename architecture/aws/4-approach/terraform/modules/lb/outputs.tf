output "main_target_group_arn" {
  description = "ARN of the main target group."
  value       = aws_lb_target_group.main.arn
}

output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = aws_lb.this.dns_name
}