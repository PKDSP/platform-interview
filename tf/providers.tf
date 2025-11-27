terraform {
  required_version = ">= 1.0.7"
  required_providers {
    docker = { source  = "kreuzwerker/docker", version = "3.6.2" }
    vault = { source  = "hashicorp/vault", version = "3.0.1" }
  }
}

variable "vault_token_dev" {}
variable "vault_token_staging" {}
variable "vault_token_prod" {}
variable "vault_token_config" {}

provider "vault" { alias   = "vault_dev"; address = "http://localhost:8201"; token   = var.vault_token_dev }
provider "vault" { alias   = "vault_staging"; address = "http://localhost:8401"; token   = var.vault_token_staging }
provider "vault" { alias   = "vault_prod"; address = "http://localhost:8301"; token   = var.vault_token_prod }
provider "vault" { alias   = "config"; address = "http://vault-config:8000"; token   = var.vault_token_config }