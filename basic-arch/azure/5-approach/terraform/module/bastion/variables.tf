variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "bastion_subnet" {
  description = "Id of the subnet where this bastion is deployed."
  type        = string
}