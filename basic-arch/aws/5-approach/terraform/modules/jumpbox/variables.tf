variable "private_subnets" {
  description = "Private subnets where are the EC2 this jumpbox will SSH to."
  type = list(string)
}

variable "jumpbox_subnet" {
  description = "Subnet where this jumpbox is deployed."
  type = string
}

variable "vpc_id" {
  description = "Id of the VPC."
  type        = string
}