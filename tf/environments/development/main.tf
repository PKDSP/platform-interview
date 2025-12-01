# 1. Terrafrom required versions and providers #############################
terraform {
  required_version = ">= 1.0.7"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

# 2. Docker providers ###########################
provider "docker" {
  alias = "docker"
}

# 3. Defining local variables in local block ###################
locals {
  # Load the SPOT config
  catalog_data = jsondecode(file("${path.module}/../../environments/development/config/settings.json"))
  # Environment configuration
  environment = local.catalog_data.vault.env_name

}
# 4. Start of the module call #####################################
module "common" {
  source                = "../../modules/common"
  microservice_env_name = local.environment
}

# 5. Storing terraform state in local for dev enviornment #########################
terraform {
  backend "local" {
    path = "../../terraform-development.tfstate"
  }
}

# 6. OutPut of the deployed services#################
output "vault_address" {
  description = "The address of the Vault server for the dev environment."
  value       = local.catalog_data.vault.address
}

output "frontend_url" {
  description = "The URL to access the frontend application."
  value       = "http://localhost:${local.catalog_data.frontend.external_ports.development}"
}
