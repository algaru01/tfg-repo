variable "resource_group_name" {
  description = "Name of the resource group where this DB is created."
  type        = string
}

variable "location" {
  description = "Location where this DB is deployed."
  type        = string
}

variable "database_subnet" {
  description = "Private subnet where this database is deployed."
  type        = string
}

variable "vnet_id" {
  description = "Id of the main VNet."
  type        = string
}

variable "db_user" {
  description = "User of the database."
  type        = string
}

variable "db_password" {
  description = "Password of the database."
  type        = string
  sensitive   = true
}