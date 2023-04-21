variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
}

variable "subnet" {
  description = "Subnet where this VM will be working."
  type        = string
}

variable "service_email" {
  description = "Email of the service."
  type        = string
  default     = "terraform@basic-arch-384210.iam.gserviceaccount.com"
}