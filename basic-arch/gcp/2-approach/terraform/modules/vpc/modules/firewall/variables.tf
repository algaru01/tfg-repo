variable "network" {
  description = "Network to which these firewalls will be linked to."
  type        = string
}

variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}