variable "subnet_name" {
  description = "Name of the subnet to deploy instances into"
  type        = string
}

variable "firewall_name" {
  default = "app-vm-firewall"
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "machine_type" {}

variable "region" {
  description = "GCP region for managed instance group"
  type        = string
}

variable "app_instance_name" {
  description = "Base name for app instances and resources"
  type        = string
  default     = "app-instance"
}

variable "mig_target_size" {
  description = "Number of instances in the managed instance group"
  type        = number
  default     = 2
}

variable "min_replicas" {
  description = "Minimum number of replicas in the managed instance group"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Minimum number of replicas in the managed instance group"
  type        = number
  default     = 4
}