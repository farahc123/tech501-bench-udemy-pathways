provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "farah-terraform-state-bucket"
    key            = "sparta-resources/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
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
  subnet_id            = module.vpc.public_subnet_id
  security_group_id    = module.security_group_db.security_group_id
  ssh_key_name         = var.SSH_key_name
  db_instance_name     = var.db_instance_name
  db_public_ip_setting = var.db_public_ip_setting
}

module "asg_app" {
  source                = "./modules/ASG"
  ami_id                = var.ami_id
  app_instance_type     = var.app_instance_type
  subnet_id             = module.vpc.public_subnet_id
  security_group_id     = module.security_group_app.security_group_id
  ssh_key_name          = var.SSH_key_name
  app_instance_name     = var.app_instance_name
  app_public_ip_setting = var.app_public_ip_setting
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
}