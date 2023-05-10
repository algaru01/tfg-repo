variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "ss_subnet" {
  description = "Id of the subnet where this Scale Set is deployed."
  type        = string
}

variable "server_port" {
  description = "Port where the server will run."
  type        = number
  default     = 8080
}

variable "ag_backend_address_pool" {
  description = "Backend Address Pool of the Application Gateway that will be linked to this SS."
  type = string
}