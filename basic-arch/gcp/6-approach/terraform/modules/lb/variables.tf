variable "check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
}

variable "backend_group" {
  description = "Group that will act as backend of this LB."
  type        = string
}

variable "vpc" {
  description = "VPC where this LB belongs to."
}