variable "check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
}

variable "instance_group_backend" {
  description = "Instance group that will be backend of this LB."
  type        = string
}

variable "vpc" {
  description = "Network where deploy this Load Balancer"
  type        = string
}

variable "backend_port" {
  description = "Name of the port of the backend where distribute traffic."
  type        = string
}