variable "vpc_id" {
  description = "Id of the VPC."
  type        = string
}

variable "public_subnets_id" {
  description = "List of public subnets ids where this load balancer works."
  type        = list(string)
}

variable "auth_server_port" {
  description = "Server port for auth target group."
  type        = string
}

variable "products_server_port" {
  description = "Server port for products target group."
  type        = string
}