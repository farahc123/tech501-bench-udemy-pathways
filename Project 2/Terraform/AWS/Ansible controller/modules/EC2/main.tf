# which services/resources with app_instance being my local reference to the resource
resource "aws_instance" "ansible_controller" {

  # what AMI (amazon machine image) ID to use
  ami = var.ami_id

  # which type of instance, which specifies CPU cores, memory size, and storage capacity
  instance_type = var.instance_type

  # that we want a public IP
  associate_public_ip_address = var.public_ip_setting

  # specifying the SSH key to access the instance; this is already set up on AWS
  key_name = var.ssh_key_name

  vpc_security_group_ids = [var.security_group_id]

  subnet_id                   = var.subnet_id

  # naming the service/instance on AWS via tags
  tags = {
    Name = var.instance_name
  }
}
