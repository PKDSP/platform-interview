# 1. Auth Backend 
resource "vault_auth_backend" "userpass_auth" {
  provider = vault.vault_provider
  type     = "userpass"
}

# 2. Audit 
resource "vault_audit" "audit" {
  provider = vault.vault_provider
  type     = "file"
  options = {
    file_path = "/vault/logs/audit-${local.environment}"
  }
}


# 3. VAULT CONFIGURATION: Loop through all services to create Vault secrets and userpass users
module "vault_services" {
  for_each = local.services_map
  source   = "../../modules/vault"

  # Dynamic Vault Configuration
  environment          = local.environment
  microservice_name    = each.key
  vault_provider_alias = local.vault_provider_alias

  # WARNING: Hardcoding sensitive values for example. In a real scenario, these would come from a secure source.
  db_user           = each.value.username
  db_password       = each.value.password
  userpass_password = "123-${each.key}-${local.environment}"
  depends_on        = [vault_auth_backend.userpass_auth]
}

# 4. MICROSERVICE DEPLOYMENT: Loop through all services to create Docker containers
module "microservices" {
  for_each = local.services_map
  source   = "../../modules/services"

  depends_on = [module.vault_services]

  environment         = local.environment
  service_name        = each.key
  image               = each.value.image
  service_port        = each.value.port
  docker_network_name = local.network_name

  vault_addr     = "http://vault-${local.environment}:8200"
  vault_username = "${each.value.username}-${local.environment}"
  vault_password = "123-${each.key}-${local.environment}"
}

# 5. FRONTEND DEPLOYMENT
module "frontend" {
  source = "../../modules/frontend"

  environment         = local.environment
  image               = local.catalog_data.frontend.image
  docker_network_name = local.network_name
  internal_port       = local.catalog_data.frontend.internal_port
  external_port       = lookup(local.catalog_data.frontend.external_ports, local.environment)
}

