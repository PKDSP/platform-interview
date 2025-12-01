provider "vault" {
  address = local.vault_config.address
  token   = local.vault_config.token
  alias   = "vault_provider"
}

provider "vault" {
  address = local.vault_config.address
  token   = local.vault_config.token
}
