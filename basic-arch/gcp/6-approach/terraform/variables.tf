variable "server_port" {
  description = "Port where the server will be launched."
  type        = number
  default     = 8080
}

variable "service_credentials_location" {
  description = "Location of the JSON credential file from a service with needed permisions"
  type        = string
  default = "C:/Users/agalveru/Documents/gcp_credentials/basic-arch-384210-bfc55306716c.json"
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