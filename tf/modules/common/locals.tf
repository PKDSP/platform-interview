locals {
  # Load the SPOT config
  catalog_data = jsondecode(file("${path.module}/../../environments/${local.env}/config/settings.json"))
  #catalog_data = var.microservice_env_name

  # Environment configuration
  env                  = var.microservice_env_name
  environment          = local.catalog_data.vault.env_name
  network_name         = local.catalog_data.vault.network
  vault_config         = local.catalog_data.vault
  vault_provider_alias = local.catalog_data.vault.vault_alias

  # Simplified map of services for looping
  services_map = local.catalog_data.services
}
