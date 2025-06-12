provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

terraform {
  backend "s3" {
    bucket         = "farah-terraform-state-bucket"
    key            = "ansible-sparta/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

resource "aws_instance" "ansible_controller" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip_setting
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.security_group_ansible.id]
  subnet_id                   = data.aws_subnets.default_subnets.ids[0]

  tags = {
    Name = var.instance_name
  }

  user_data = file("${path.module}/scripts/prov-ansible.sh")
}
