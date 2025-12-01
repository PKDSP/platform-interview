terraform {
  required_version = ">= 1.0.7"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.0.1"
    }
  }
}
