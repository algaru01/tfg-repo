variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VNet."
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for the publics subnets in such VNet."
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets in such VNet."
  type        = list(string)
  default     = null
}

variable "bastion_subnet" {
  description = "CIDR block for the bastion subnet in such VNet."
  type        = string
  default     = null
}

variable "server_port" {
  description = "Port where the server will run."
  type        = number
  default     = 8080
}

variable "db_subnet" {
  description = "Subnet where DB will be deployed."
  type        = string
  default     = null
}