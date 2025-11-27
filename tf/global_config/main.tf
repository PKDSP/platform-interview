locals {
  service_metadata = {
    account  = { image_name = "form3tech-oss/platformtest-account", needs_vault = true },
    gateway  = { image_name = "form3tech-oss/platformtest-gateway", needs_vault = true },
    payment  = { image_name = "form3tech-oss/platformtest-payment", needs_vault = true },
    frontend = { image_name = "docker.io/nginx", needs_vault = false }
  }
}

output "service_metadata" {
  value = local.service_metadata
}