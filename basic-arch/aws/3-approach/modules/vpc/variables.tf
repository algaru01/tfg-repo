variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of the ids of the public subnets in such VPC."
  type        = list(string)
}

variable "availability_zone" {
  description = "List of the availability zone of each public subnet."
  type        = list(string)
}