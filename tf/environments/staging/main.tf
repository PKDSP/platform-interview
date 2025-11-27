module "global_config" {
  source = "../../global_config"
}

module "platform_deployment" {
  source = "../../modules/environment_config"

  environment           = "staging"
  vault_provider        = vault.vault_staging
  vault_config_provider = vault.config
  
  docker_network_name   = var.docker_network_name
  service_config        = var.service_config
  global_service_metadata = module.global_config.service_metadata
}