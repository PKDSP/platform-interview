# Design Decisions for the Terraform Project Structure

This project follows a modular and environment-driven Terraform architecture designed to support scalability and maintainability across multiple environments. The directory layout and configuration patterns were chosen intentionally to ensure separation of concerns, reusable infrastructure logic, Vault integration, and predictable CI/CD workflows.

```
├── Readme.md
├── environments
│   ├── development
│   │   ├── config
│   │   │   └── settings.json
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── production
│   │   ├── config
│   │   │   └── settings.json
│   │   ├── main.tf
│   │   └── variables.tf
│   └── staging
│       ├── config
│       │   └── settings.json
│       ├── main.tf
│       └── variables.tf
├── modules
│   ├── common
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── frontend
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   ├── services
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── variables.tf
│   └── vault
│       ├── locals.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── variables.tf
└── providers.tf
```
## 1. Separation of Environments

Each environment (development, staging, production) resides in its own folder under environments/, containing:

- main.tf – environment-specific Terraform execution

- variables.tf – input variables for that environment

- config/settings.json – any additional environment configuration

### Why this design?

- Ensures strict isolation between environments

- Prevents accidental changes in production

- Allows environment-specific overrides (Vault URLs, tokens, networks, ports)

- Makes deployments predictable and CI/CD-compatible

- Each environment can have its own Terraform state file

### Design intent

main.tf, variables.tf, and config/settings.json inside each environment ensures that environment differences are isolated and controlled without duplicating module logic.