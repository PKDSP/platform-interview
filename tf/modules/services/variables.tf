variable "environment" {
  description = "The deployment environment (dev, stage, or prod)."
  type        = string
}

variable "service_name" {
  description = "The name of the microservice (e.g., account, payment)."
  type        = string
}

variable "image" {
  description = "The Docker image name for the microservice container."
  type        = string
}

variable "service_port" {
  description = "The internal port used by the microservice application."
  type        = number
}

variable "docker_network_name" {
  description = "The name of the Docker network to attach the container to."
  type        = string
}

variable "vault_addr" {
  description = "The address of the Vault server."
  type        = string
}

variable "vault_username" {
  description = "The Vault userpass username for the container to log in with."
  type        = string
}

variable "vault_password" {
  description = "The Vault userpass password for the container."
  type        = string
  sensitive   = true
}

