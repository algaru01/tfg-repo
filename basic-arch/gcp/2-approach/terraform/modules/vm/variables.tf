variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}

variable "subnet" {
  description = "Subnet where this VM will be working."
  type        = string
}

variable "number_vms" {
  description = "Number of Virtual Machines to be created."
  type        = number
}