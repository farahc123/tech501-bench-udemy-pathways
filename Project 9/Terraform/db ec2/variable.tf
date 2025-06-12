# Creating variables to be used with AWS instances and security groups

variable "ami_id" {
  default = "ami-032a56ad5e480189c"
}

variable "region" {
  default = "eu-west-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "SSH_key_name" {
  default = "tech501-farah-aws-key"
}

variable "instance_name" {
  default = "tech501-farah-ansible-terraform-db"
}

variable "security_group_name" {
  default = "tech257-farah-ansible-tf-allow-port-22-27017"
}

variable "vpc_id" {
  default = "vpc-07e47e9d90d2076da"
}

variable "all_cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "public_ip_setting" {
  default = true
}