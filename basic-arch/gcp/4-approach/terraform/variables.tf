variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
  default     = 8080
}

variable "db_user" {
  description = "User for the created database."
  type        = string
  default     = "usuario"
}

variable "db_password" {
  description = "Password for the user of the database."
  type        = string
  sensitive   = true
  default     = "password"
}