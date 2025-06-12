output "instance_template_id" {
  value       = google_compute_instance_template.app_template.id
  description = "ID of the instance template"
}

output "managed_instance_group_name" {
  value       = google_compute_region_instance_group_manager.app_mig.name
  description = "Name of the managed instance group"
}
