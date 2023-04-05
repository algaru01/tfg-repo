variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnets in such VPC."
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "You must have at least 2 public subnets."
  }

}