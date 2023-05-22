variable "location" {
  description = "Location of the Cloud Run service."
  type = string
}

variable "ar_name" {
  description = "Name of the Artifact Registry where Docker images are stored."
}

variable "db_address" {
  description = "Address of the database."
  type        = string
}

variable "db_user" {
  description = "User of the database."
  type        = string
}

variable "db_password" {
  description = "Password of the database."
  type        = string
}

variable "db_port" {
  description = "Password of the database."
  type        = string
}

variable "connector" {
  description = "Connector used to use services in VPC"
  type        = string
}