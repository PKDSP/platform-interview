# 1. Store the database secret
resource "vault_generic_secret" "db_secret" {
  path = "secret/${local.secret_path}"

  data_json = jsonencode({
    db_user     = var.db_user
    db_password = var.db_password
  })
}

# 2. Define the read policy for the secret
resource "vault_policy" "read_policy" {
  name = local.policy_name

  policy = <<-EOT
path "secret/data/${local.secret_path}" {
  capabilities = ["list", "read"]
}
EOT
}

# 3. Create the userpass endpoint/user
resource "vault_generic_endpoint" "userpass_user" {
  path                 = local.endpoint_path
  ignore_absent_fields = true

  data_json = jsonencode({
    policies = [local.policy_name],
    password = var.userpass_password
  })
}
