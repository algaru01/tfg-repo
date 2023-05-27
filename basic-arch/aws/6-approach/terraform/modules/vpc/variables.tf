variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of the CIDR blocks for each public subnet to be created in such VPC."
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "List of the CIDR blocks for each private subnet to be created in such VPC."
  type        = list(string)
  default     = null
}

variable "nat_subnet" {
  description = "CIDR for the Public subnet where the NAT gateway that private subnets use will be placed."
  type = string
}

variable "public_subnets_availability_zone" {
  description = "List of the availability zone of each public subnet."
  type        = list(string)
}

variable "private_subnets_availability_zone" {
  description = "List of the availability zone of each private subnet."
  type        = list(string)
}