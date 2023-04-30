variable "vpc_id" {
  description = "Id of the VPC."
  type        = string
}

variable "db_subnets" {
  description = "List of subnet where this database can be provisioned in."
  type        = list(string)
}

variable "port" {
  description = "Port to communicate with database."
  type        = string
}

variable "username" {
  description = "Username for the RDS."
  type        = string
}

variable "password" {
  description = "Password for the RDS."
  type        = string
  sensitive   = true
}