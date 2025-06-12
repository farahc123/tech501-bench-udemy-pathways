variable "firewall_name" {
  default = "db-vm-firewall"
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
  type        = string
}

variable "source_ranges" {
  description = "CIDR blocks allowed to access the VM"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vm_tag" {
  description = "Tag applied to VM and firewall target"
  default     = "db-vm"
}

variable "instance_name" {
  description = "Name of the Compute Engine instance"
  default     = "db-vm"
}

variable "machine_type" {}

variable "zone" {
  description = "GCP zone for the instance"
  type        = string
}

variable "image" {
  description = "Compute Engine image self_link"
  type        = string
}