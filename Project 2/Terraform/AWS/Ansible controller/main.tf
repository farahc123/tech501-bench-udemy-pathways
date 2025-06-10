provider "aws" {
  region = var.region
}

module "security_group_ansible" {
  source                      = "./modules/security_group_ansible"
  ansible_security_group_name = var.security_group_name
  vpc_id                      = var.vpc_id
}

module "ec2_ansible" {
  region            = var.region
  source            = "./modules/EC2/"
  subnet_id         = var.subnet_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  security_group_id = module.security_group_ansible.security_group_id
  ssh_key_name      = var.ssh_key_name
  instance_name     = var.instance_name
  public_ip_setting = var.public_ip_setting
}
