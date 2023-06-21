variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}

variable "subnets" {
  description = "List of CIDRs for the subnets."
  type        = list(string)
}

variable "proxy_subnets" {
  description = "List of CIDRs for the proxy subnets."
  type        = list(string)
}