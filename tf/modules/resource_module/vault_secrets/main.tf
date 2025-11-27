variable "vault_provider" { type = any }
variable "auth_backend_dependency" { type = any }
variable "environment" { type = string }
variable "service_name" { type = string }
variable "secret_data" { type = map(string) }
variable "user_password" { type = string }

resource "vault_generic_secret" "app_secret" {
  provider = var.vault_provider; 
  path = "secret/${var.environment}/${var.service_name}"; 
  data_json = jsonencode(var.secret_data)
}

resource "vault_policy" "app_policy" {
  provider = var.vault_provider; name = "${var.service_name}-${var.environment}"
  policy = <<-EOT
path "secret/data/${var.environment}/${var.service_name}" {
    capabilities = ["list", "read"]
}
EOT
}

resource "vault_generic_endpoint" "app_user" {
  provider = var.vault_provider; path = "auth/userpass/users/${var.service_name}-${var.environment}"
  depends_on = [var.auth_backend_dependency]; ignore_absent_fields = true
  data_json = jsonencode({ policies = [vault_policy.app_policy.name], password = var.user_password })
}

output "vault_username" { value = "${var.service_name}-${var.environment}" }
output "vault_user_endpoint" { value = vault_generic_endpoint.app_user }