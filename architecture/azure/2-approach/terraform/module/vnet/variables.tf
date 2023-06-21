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
}

variable "server_port" {
  description = "Port where the server will run."
  type        = number
  default     = 8080
}