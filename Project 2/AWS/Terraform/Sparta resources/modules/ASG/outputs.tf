output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  description = "Name of the ASG"
  value       = aws_autoscaling_group.app_asg.name
}