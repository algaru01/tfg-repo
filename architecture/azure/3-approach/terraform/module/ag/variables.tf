variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "backend_port" {
  description = "Port where distribute traffic in backend."
  type        = number
  default     = 8080
}

variable "ag_subnet" {
  description = "Subnet where this Application Gateway will be deployed."
  type        = string
}