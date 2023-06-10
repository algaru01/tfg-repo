variable "vpc" {
  description = "Producer VPC form where connect to this DB."
  type        = string
}

variable "db_user" {
  description = "User for the created database."
  type        = string
}

variable "db_password" {
  description = "Password for the user of the database."
  type        = string
  sensitive   = true
}