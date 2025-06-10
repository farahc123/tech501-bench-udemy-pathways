provider "aws" {
  region = var.region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az_public           = var.az_public
  az_private          = var.az_private
}

module "security_group_db" {
  source                 = "./modules/security_group_db"
  db_security_group_name = var.db_security_group_name
  vpc_id                 = module.vpc.vpc_id
  vpc_cidr               = module.vpc.vpc_cidr
}

module "security_group_app" {
  source                  = "./modules/security_group_app"
  app_security_group_name = var.app_security_group_name
  vpc_id                  = module.vpc.vpc_id
}

module "ec2_db" {
  source               = "./modules/EC2/DB"
  ami_id               = var.ami_id
  db_instance_type     = var.db_instance_type
  subnet_id            = module.vpc.private_subnet_id
  security_group_id    = module.security_group_db.security_group_id
  ssh_key_name         = var.SSH_key_name
  db_instance_name     = var.db_instance_name
  db_public_ip_setting = var.db_public_ip_setting
}

module "ec2_app" {
  source                = "./modules/EC2/app"
  ami_id                = var.ami_id
  app_instance_type     = var.app_instance_type
  subnet_id             = module.vpc.public_subnet_id
  security_group_id     = module.security_group_app.security_group_id
  ssh_key_name          = var.SSH_key_name
  app_instance_name     = var.app_instance_name
  app_public_ip_setting = var.app_public_ip_setting
}