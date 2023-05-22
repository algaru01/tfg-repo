variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of the CIDR blocks for each public subnet to be created in such VPC."
  type        = list(string)
  default     = null
}

variable "availability_zone" {
  description = "List of the availability zone of each public subnet."
  type        = list(string)
}