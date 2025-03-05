# create a clean ec2 instance to be used as my db VM for ansible project 9

# where to create the EC2 instance - provide cloud provider's name

provider "aws" {
  # which region to use (where to create these resources) -- the below is the same as Ireland
  region = var.region
}

# which services/resources with db_instance being my local reference to the resource
resource "aws_instance" "db_instance" {

  # what AMI (amazon machine image) ID to use
  ami = var.ami_id

  # which type of instance, which specifies CPU cores, memory size, and storage capacity
  instance_type = var.instance_type

  # that we want a public IP
  associate_public_ip_address = var.public_ip_setting

  # attaching the security group defined in security_groups file to the default VPC we have been using
  vpc_security_group_ids = [aws_security_group.public.id]

  # specifying the SSH key to access the instance; this is already set up on AWS
  key_name = var.SSH_key_name

  # naming the service/instance on AWS via tags
  tags = {
    Name = var.instance_name
  }
}
