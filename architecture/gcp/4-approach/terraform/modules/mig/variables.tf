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

variable "db_address" {
  description = "Address to which connect to the database"
  type        = string
}

variable "db_user" {
  description = "User of the database"
  type        = string
}

variable "db_password" {
  description = "Password of the user of the database"
  type        = string
  sensitive   = true
}