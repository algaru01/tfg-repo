variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}

variable "subnets" {
  description = "List of CIDRs for the subnets."
  type        = list(string)
}