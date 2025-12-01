resource "docker_container" "microservice" {
  image = var.image
  name  = "${var.service_name}_${var.environment}"

  env = [
    "VAULT_ADDR=${var.vault_addr}",
    "VAULT_USERNAME=${var.vault_username}",
    "VAULT_PASSWORD=${var.vault_password}",
    "ENVIRONMENT=${var.environment}",
    "SERVICE_PORT=${var.service_port}"
  ]

  networks_advanced {
    name = var.docker_network_name
  }

  lifecycle {
    ignore_changes = all
  }
}

