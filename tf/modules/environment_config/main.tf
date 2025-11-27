variable "environment" { type = string }
variable "vault_provider" { type = any }
variable "vault_config_provider" { type = any }
variable "docker_network_name" { type = string }
variable "service_config" { type = map(object({ version = string, external_port = optional(number) })) }
variable "global_service_metadata" { type = map(object({ image_name = string, needs_vault = bool })) }

# 1. Dynamic Vault Address Lookup
data "vault_generic_secret" "environment_config" {
  provider = var.vault_config_provider
  path     = "secret/config/${var.environment}"
}

locals {
  vault_addr = data.vault_generic_secret.environment_config.data["vault_addr"]
  
  # 2. Merge Global Metadata with Local Environment Config
  deployment_map = {
    for service_name, config in var.global_service_metadata : service_name => merge(
      config,
      var.service_config[service_name],
      { external_port = lookup(var.service_config[service_name], "external_port", null) }
    )
  }
}

# 3. Base Vault Setup (Authentication Backend)
resource "vault_auth_backend" "userpass" { provider = var.vault_provider; type = "userpass" }

# 4. Deploy ALL services dynamically
module "microservice" {
  for_each = local.deployment_map
  source   = "../service_deployer"

  environment           = var.environment
  docker_network_name   = var.docker_network_name
  vault_provider        = var.vault_provider
  vault_addr            = local.vault_addr # Dynamically fetched
  auth_backend_dependency = vault_auth_backend.userpass
  
  service_name          = each.key
  image_name            = each.value.image_name
  image_tag             = each.value.version
  external_port         = each.value.external_port
  needs_vault           = each.value.needs_vault
}