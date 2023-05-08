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

variable "lb_backend_address_pool_id" {
  description = "Id of Load Balancer backend address pool."
  type        = string
}

variable "lb_rule" {
  description = "Id of a Load Balancer rule."
  type        = string
}

variable "lb_probe" {
  description = "Id of the Load Balancer probe."
  type        = string
}

variable "db_address" {
  description = "Address of the database."
  type        = string
}

variable "db_user" {
  description = "User of the database."
  type        = string
}

variable "db_password" {
  description = "Password of the database."
  type        = string
}