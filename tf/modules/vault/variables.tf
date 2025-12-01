variable "environment" {
  description = "The deployment environment (dev, stage, or prod)."
  type        = string
}

variable "microservice_name" {
  description = "The name of the microservice (e.g., account, payment)."
  type        = string
}

variable "vault_provider_alias" {
  description = "The alias of the configured Vault provider (e.g., vault_dev)."
  type        = string
}

variable "db_password" {
  description = "The database password for the service (should be secure/random)."
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The database username for the service."
  type        = string
}

variable "userpass_password" {
  description = "The Vault userpass password for the microservice login."
  type        = string
  sensitive   = true
}
