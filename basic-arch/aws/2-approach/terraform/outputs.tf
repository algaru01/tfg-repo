output "public_ip" {
  value       = module.ec2.public_ips
  description = "List of IPs for the EC2 in the public subnets."
}