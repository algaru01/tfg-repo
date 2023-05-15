variable "check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
}

variable "instance_group_backend" {
  description = "Instance group that will be backend of this LB."
  type        = string
}