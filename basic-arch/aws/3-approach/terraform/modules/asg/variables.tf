variable "vpc_id" {
  description = "Id of the VPC."
  type        = string
}

variable "public_subnets_id" {
  description = "List of public subnets ids where this autoscaling group works."
  type        = list(string)
}

variable "server_port" {
  description = "Server port for target group."
  type        = string
}

variable "target_group_arns" {
  description = "List of target group arns that points to this autscaling group."
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of EC2 instances."
  type        = number
}

variable "max_size" {
  description = "Maximum number of EC2 instances."
  type        = number
}