locals {
  service_username = "${var.microservice_name}-${var.environment}"
  secret_path      = "${var.environment}/${var.microservice_name}"
  policy_name      = "${var.microservice_name}-${var.environment}"
  endpoint_path    = "auth/userpass/users/${local.service_username}"
}
