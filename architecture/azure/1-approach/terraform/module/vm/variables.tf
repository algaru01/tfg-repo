variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "subnet" {
  description = "Id of the subnet where this VM is deployed."
  type        = string
}

variable "server_port" {
  description = "Port where the server will run."
  type        = number
  default     = 8080
}

variable "number_instances" {
  description = "Number of VM instances to be created."
  type        = number
}