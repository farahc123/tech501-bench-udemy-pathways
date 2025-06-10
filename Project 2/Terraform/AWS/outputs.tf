output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "db_security_group_id" {
  value = module.security_group_db.security_group_id
}

output "app_security_group_id" {
  value = module.security_group_app.security_group_id
}

output "db_ec2_instance_id" {
  value = module.ec2_db.instance_id
}

output "app_ec2_instance_id" {
  value = module.ec2_app.instance_id
}