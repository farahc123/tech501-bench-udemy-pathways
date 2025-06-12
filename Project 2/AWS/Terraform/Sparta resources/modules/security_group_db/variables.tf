variable "db_security_group_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}
