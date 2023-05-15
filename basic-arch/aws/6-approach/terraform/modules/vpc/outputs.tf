output "vpc_id" {
  description = "Id of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnets_id" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets_id" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

/* output "jumpbox_subnet_id" {
  description = "ID of the jumpbox subnet"
  value       = aws_subnet.jumpbox[0].id
} */