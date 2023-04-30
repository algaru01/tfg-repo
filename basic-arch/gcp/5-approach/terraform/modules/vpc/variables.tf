variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}

variable "public_subnets" {
  description = "List of CIDRs for the public subnets."
  type        = list(string)
}

variable "lb_address" {
  description = "Address of the load balancer"
  type = string
}

variable "jumpbox_address" {
  description = "Address of the jumpbox"
  type = string
}