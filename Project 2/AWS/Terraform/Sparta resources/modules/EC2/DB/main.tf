resource "aws_instance" "mongodb_vm" {
  ami                         = var.ami_id
  instance_type               = var.db_instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                   = var.ssh_key_name
  associate_public_ip_address = var.db_public_ip_setting

  tags = {
    Name = var.db_instance_name
    Environment = "Test"
  }
}
