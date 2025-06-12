variable "ami_id" {}
variable "db_instance_type" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "ssh_key_name" {}
variable "db_instance_name" {}
variable "db_public_ip_setting" {
  type    = bool
  default = true
}
