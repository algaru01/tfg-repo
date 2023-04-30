variable "network" {
  description = "Network to which these firewalls will be linked to."
  type        = string
}

variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}

variable "lb_address" {
  description = "Address of the load balancer"
  type = string
}

variable "jumpbox_address" {
  description = "Address of the jumpbox"
  type = string
}