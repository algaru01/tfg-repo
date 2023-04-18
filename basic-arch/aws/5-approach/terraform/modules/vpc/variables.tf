variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "CIDR block for the public subnets in such VPC."
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR block for the private subnets in such VPC."
  type        = list(string)
}

variable "jumpbox_subnet" {
  description = "Subnet to deploy the jumpbox."
  type        = string
}

variable "availability_zone" {
  description = "List of the availability zone of each subnet."
  type        = list(string)
}