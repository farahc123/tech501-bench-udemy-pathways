resource "aws_launch_template" "app" {
  name_prefix   = "${var.app_instance_name}-lt-"
  image_id      = var.ami_id
  instance_type = var.app_instance_type
  key_name      = var.ssh_key_name

  network_interfaces {
    associate_public_ip_address = var.app_public_ip_setting
    security_groups             = [var.security_group_id]
    subnet_id                   = var.subnet_id
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.app_instance_name
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.app_instance_name}-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = [var.subnet_id]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.app_instance_name
    propagate_at_launch = true
  }
}