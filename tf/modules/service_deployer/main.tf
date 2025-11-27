variable "environment" { type = string }
variable "service_name" { type = string }
variable "image_name" { type = string }
variable "image_tag" { type = string }
variable "docker_network_name" { type = string }
variable "external_port" { type = number, default = null }
variable "vault_addr" { type = string }
variable "needs_vault" { type = bool }
variable "vault_provider" { type = any }
variable "auth_backend_dependency" { type = any }

data "docker_registry_image" "service_image" { name = "${var.image_name}:${var.image_tag}" }

resource "random_password" "db_secret" { count = var.needs_vault ? 1 : 0; length = 32; special = false }
resource "random_password" "vault_user_pass" { count = var.needs_vault ? 1 : 0; length = 16; special = false }

module "vault" {
  source = "../resource_modules/vault_secrets"; count = var.needs_vault ? 1 : 0
  vault_provider = var.vault_provider; environment = var.environment
  auth_backend_dependency = var.auth_backend_dependency; service_name = var.service_name
  secret_data = { db_user = var.service_name, db_password = random_password.db_secret[0].result }
  user_password = random_password.vault_user_pass[0].result
}

module "app" {
  source = "../resource_modules/app_service"
  environment = var.environment; image_tag = var.image_tag; docker_network_name = var.docker_network_name
  vault_addr = var.vault_addr; service_name = var.service_name
  image_name = data.docker_registry_image.service_image.name; external_port = var.external_port
  vault_username = var.needs_vault ? module.vault[0].vault_username : ""
  vault_password = var.needs_vault ? random_password.vault_user_pass[0].result : ""
  vault_user_dependency = var.needs_vault ? module.vault[0].vault_user_endpoint : []
}