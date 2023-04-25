variable "vpc" {
  description = "Private network where this db is deployed."
  type = string
}

variable "db_user" {
  description = "User for the created database."
  type        = string
}

variable "db_password" {
  description = "Password for the user of the database."
  type = string
  sensitive = true
}