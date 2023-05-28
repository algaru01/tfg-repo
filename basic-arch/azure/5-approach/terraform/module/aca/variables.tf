variable "resource_group_name" {
  description = "Name of the resource group where these resources belong to."
  type        = string
}

variable "location" {
  description = "Location where these resources are deployed."
  type        = string
}

variable "subnet" {
  description = "Subnet where Containers will be deployed."
  type        = string
}

variable "acr_username" {
  description = "Username of the ACR."
  type        = string
}

variable "acr_password" {
  description = "Password of the ACR."
  type        = string
  sensitive   = true
}

variable "acr_login_server" {
  description = "Login server of the ACR."
  type        = string
}


variable "db_address" {
  description = "Address of the database."
  type        = string
}

variable "db_port" {
  description = "Posrt of the database."
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

variable "products_ingress_target_port" {
  description = "The target port on the container for the Ingress traffic."
  type        = string
}

variable "auth_ingress_target_port" {
  description = "The target port on the container for the Ingress traffic."
  type        = string
}

/* variable "auth_url" {
  description = "URL of the auth service."
  type        = string
} */