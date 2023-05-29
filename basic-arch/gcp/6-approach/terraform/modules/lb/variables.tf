variable "check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
}

variable "products_backend_group" {
  description = "Porducts group that will act as one of the backends of this LB."
  type        = string
}

variable "auth_backend_group" {
  description = "Auth group that will act as one of the backends of this LB."
  type        = string
}

variable "vpc" {
  description = "VPC where this LB belongs to."
}