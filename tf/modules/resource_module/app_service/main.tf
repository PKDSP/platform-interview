variable "environment" { type = string }
variable "service_name" { type = string }
variable "image_name" { type = string }
variable "image_tag" { type = string }
variable "docker_network_name" { type = string }
variable "external_port" { type = number, default = null }
variable "vault_addr" { type = string }
variable "vault_username" { type = string, default = "" }
variable "vault_password" { type = string, default = "" }
variable "vault_user_dependency" { type = any, default = [] }

resource "docker_container" "app" {
  image = "${var.image_name}:${var.image_tag}"; name  = "${var.service_name}_${var.environment}"
  env = [ "VAULT_ADDR=${var.vault_addr}", "VAULT_USERNAME=${var.vault_username}", "VAULT_PASSWORD=${var.vault_password}", "ENVIRONMENT=${var.environment}" ]
  dynamic "ports" { for_each = var.external_port != null ? [1] : []; content { internal = 80; external = var.external_port } }
  networks_advanced { name = var.docker_network_name }
  lifecycle { ignore_changes = all }
  depends_on = [var.vault_user_dependency]
}