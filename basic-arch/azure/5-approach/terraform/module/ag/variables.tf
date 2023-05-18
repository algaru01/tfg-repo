variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "server_port" {
  description = "Port where the server will run."
  type        = number
  default     = 8080
}

variable "ag_subnet" {
  description = "Subnet where this Application Gateway will be deployed."
  type = string
}

variable "backend_fqdn" {
  description = "List of FQDNS to use as as backends"
  type        = string
}

variable "backend_ips" {
  type        = list(string)
}