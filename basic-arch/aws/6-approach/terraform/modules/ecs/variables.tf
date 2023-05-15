variable "public_subnets" {
    type = list(string)
}

variable "lb_target_group_arn" {
  type = string
}

variable "lb_sg" {
  type = string
}

variable "vpc" {
  type = string
}

variable "prefix" {
  type = string
  default = "my"
}

variable "repository_url" {
  type = string
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

variable "region" {
  description = "Region where this ECS will be deployed."
  type        = string
}

variable "server_port" {
  description = "Port where the server will be deployed."
  type        = string
}