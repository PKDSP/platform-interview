data "terraform_remote_state" "types_config" {
  backend = "local"
  config  = { path = "../../" } 
}

variable "docker_network_name" {
  type    = string
  default = "vagrant_development"
}

variable "service_config" {
  description = "Local configuration for versions and ports."
  type        = map(data.terraform_remote_state.types_config.outputs.service_config_schema) 
  default = {
    account  = { version = "latest" },
    gateway  = { version = "latest" },
    payment  = { version = "latest" },
    frontend = { version = "latest", external_port = 4080 } 
  }
}