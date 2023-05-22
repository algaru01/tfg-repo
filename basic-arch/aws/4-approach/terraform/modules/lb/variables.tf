variable "vpc_id" {
  description = "Id of the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets where this load balancer works."
  type        = list(string)
}

variable "server_port" {
  description = "Server port for target group."
  type        = string
}