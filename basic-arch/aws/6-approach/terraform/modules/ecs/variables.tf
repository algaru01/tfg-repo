variable "vpc" {
  description = "ID of the VPC where these services will be deployed."
  type        = string
}

variable "subnets" {
  description = "Subnets where these services will be deployed."
  type        = list(string)
}

variable "lb_auth_target_group_arn" {
  description = "ARN of the LB target group that will distribuite traffic to the auth service."
  type        = string
}

variable "lb_products_target_group_arn" {
  description = "ARN of the LB target group that will distribuite traffic to the products service."
  type        = string
}

variable "lb_sg" {
  description = "Unique security group from where these services will accept TCP traffic, in this case form the LB."
  type        = string
}

variable "prefix" {
  description = "Prefix used for naming instances."
  type        = string
  default     = "my"
}

variable "repository_url" {
  description = "URL of the respository where image used will be recovered from."
  type        = string
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

variable "auth_url" {
  description = "URL to access to the Auth service."
  type        = string
}

variable "region" {
  description = "Region where this ECS will be deployed."
  type        = string
}

variable "auth_server_port" {
  description = "Port where the auth server will be deployed."
  type        = string
}

variable "products_server_port" {
  description = "Port where the products server will be deployed."
  type        = string
}