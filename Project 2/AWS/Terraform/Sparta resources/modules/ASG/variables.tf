variable "ami_id" {}
variable "app_instance_type" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "ssh_key_name" {}
variable "app_instance_name" {}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "asg_desired_capacity" {}
variable "app_public_ip_setting" {
  type    = bool
  default = true
}
