# This output defines the authoritative contract for environment configuration
data "terraform_version" "schema_contract" {}

locals {
  service_config_schema = object({
    version       = string
    external_port = optional(number)
  })
}

output "service_config_schema" {
  value = local.service_config_schema
}