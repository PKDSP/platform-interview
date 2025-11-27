data "terraform_remote_state" "types_config" {
  backend = "local"
  config  = { path = "../../" } 
}

variable "docker_network_name" {
  type    = string
  default = "vagrant_staging"
}

variable "service_config" {
  description = "Local configuration for versions and ports."
  type        = map(data.terraform_remote_state.types_config.outputs.service_config_schema) 
  default = {
    account  = { version = "v1.1.0-rc1" },
    gateway  = { version = "v1.1.0-rc1" },
    payment  = { version = "v1.1.0-rc1" },
    frontend = { version = "1.23.0-alpine", external_port = 8080 }
  }
}