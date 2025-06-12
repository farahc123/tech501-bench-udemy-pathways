variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "sparta-app-462710"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-north1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-north1-a"
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "ansible-terraform-controller"
}

variable "machine_type" {
  description = "GCP machine type"
  type        = string
  default     = "e2-medium"
}

variable "image_project" {
  description = "GCP project that hosts the image"
  type        = string
  default     = "ubuntu-os-cloud"
}

variable "ansible_firewall_name" {
  description = "Firewall rule name for Ansible instance"
  type        = string
  default     = "ansible-firewall"
}

variable "all_cidr_blocks" {
  description = "CIDR blocks allowed to access the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
