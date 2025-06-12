variable "project_id" {
  default = "sparta-app-462710"
}

variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "vpc_name" {
  default = "sparta-vpc"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "machine_type" {
  description = "Compute Engine machine type"
  default     = "e2-medium"
}