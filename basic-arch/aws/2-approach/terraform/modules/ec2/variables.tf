variable "number_instances" {
  description = "Number of EC2 instances ot be created."
  type        = number
}

variable "subnet" {
  description = "Public subnet where each instance belongs to."
  type        = string
}

variable "server_port" {
  description = "Port where the server will run."
  type        = number
}

variable "vpc" {
  description = "VPC where these EC2 belong to."
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block to allow its internal traffic."
  type        = string
}