variable "region" {
  default = "eu-north-1"
}

variable "az" {
  default = "eu-north-1a"
}

variable "security_group_name" {
  default = "ansible_sg"
}

variable "ami_id" {
  default = "ami-05d3e0186c058c4dd"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ssh_key_name" {
  default = "target-vm"
}

variable "instance_name" {
  default = "ansible_terraform_controller"
}

variable "public_ip_setting" {
  default = true
}

variable "all_cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "ansible_security_group_name" {
  default = "ansible_sg"
}