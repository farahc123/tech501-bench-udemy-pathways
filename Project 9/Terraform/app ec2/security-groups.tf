# creating the security group for the EC2 instance defined in main file

# public is our local reference to this security group; the vpc id (which points to the default VPC we have been using) has been retrieved manually from AWS

resource "aws_security_group" "public" {
  name        = var.security_group_name
  description = "Setup for my Ansible target node"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.security_group_name
  }
}

# outbound rule
# minus 1 protocol means all protocols
# port 0 is a wildcard telling the system to use whichever port is appropriate for the given protocol (we are allowing all with -1, as above)

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.all_cidr_blocks

  security_group_id = aws_security_group.public.id
}

# inbound rules

resource "aws_security_group_rule" "public_in_ssh_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.all_cidr_blocks
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_http_all" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.all_cidr_blocks
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_app_all" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = var.all_cidr_blocks
  security_group_id = aws_security_group.public.id
}
