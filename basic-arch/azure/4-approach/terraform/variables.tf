variable "server_port" {
  description = "Port where the server will run."
  type        = number
  default     = 8080
}

variable "db_user" {
  description = "User of the database."
  type        = string
  default     = "usuario"
}

variable "db_password" {
  description = "Password of the database."
  type        = string
  sensitive   = true
  default     = "password"
}