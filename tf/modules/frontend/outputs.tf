output "frontend_container_id" {
  description = "The ID of the deployed frontend container."
  value       = docker_container.frontend.id
}

output "container_name" {
  description = "The name of the deployed frontend container."
  value       = local.container_name
}
