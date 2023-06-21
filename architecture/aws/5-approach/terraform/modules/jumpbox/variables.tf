variable "jumpbox_subnet" {
  description = "Subnet where this jumpbox is deployed."
  type        = string
}

variable "vpc_id" {
  description = "Id of the VPC."
  type        = string
}