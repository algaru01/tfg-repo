output "public_ips" {
  description = "List of IPs of the EC2 in public subnets."
  value = aws_instance.ec2[*].public_ip
}