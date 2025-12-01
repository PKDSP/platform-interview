variable "environment" {
  description = "The deployment environment (dev, stage, or prod)."
  type        = string
}

variable "image" { # This replaces 'frontend_image'
  description = "The Docker image name for the frontend container."
  type        = string
}

variable "docker_network_name" { # This replaces 'network_name'
  description = "The name of the Docker network to attach the container to."
  type        = string
}

variable "internal_port" {
  description = "The internal port of the container."
  type        = number
}

variable "external_port" {
  description = "The external port to expose the frontend on."
  type        = number
}
