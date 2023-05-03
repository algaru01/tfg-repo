variable "vpc" {
  description = "Private network where you will use."
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