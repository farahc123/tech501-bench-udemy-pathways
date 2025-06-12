variable "region" {
  default = "eu-north-1"
}

variable "vpc_name" {
  default = "sparta-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "az_public" {
  default = "eu-north-1a"
}

variable "az_private" {
  default = "eu-north-1b"
}

variable "db_security_group_name" {
  default = "private_sg"
}

variable "app_security_group_name" {
  default = "public_sg"
}

variable "ami_id" {
  default = "ami-05d3e0186c058c4dd"
}

variable "db_instance_type" {
  default = "t3.micro"
}

variable "app_instance_type" {
  default = "t3.small"
}

variable "SSH_key_name" {
  default = "target-vm"
}

variable "app_instance_name" {
  default = "app_instance"
}

variable "db_instance_name" {
  default = "mongodb_instance"
}

variable "app_public_ip_setting" {
  type    = bool
  default = true
}

variable "db_public_ip_setting" {
  type    = bool
  default = true
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}