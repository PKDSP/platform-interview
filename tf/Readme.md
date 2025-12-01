# Design Decisions for the Terraform Project Structure

This directory structure was chosen to ensure:

- Environment isolation

- Reusability through modules

- Secure and scalable Vault integration

- Supports Service Scalability

- Clean separation of logic vs configuration

- CI/CD compatibility

- Long-term maintainability

Overall, this architecture ensures that the infrastructure remains modular, secure, reproducible, and easy to extend as new services and environments are added.

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


## 2. Reusable Modules

All infrastructure logic is implemented inside the modules/ directory, grouped by domain:

- common – shared logic such as locals and provider configurations

- frontend – logic for frontend (Nginx) infrastructure

- services – microservices (account, gateway, payment)

- vault – Vault secrets, policies, auth backends, and secrets engines

### Why this design?

- Enforces the DRY principle (Don’t Repeat Yourself)

- Ensures infrastructure components are reusable across environments

- Keeps environment folders lightweight

- Avoids duplication of Docker, Vault, and policy logic

- Supports future services (e.g., adding billing, notification, etc.) without restructuring the project

Modules define “what” to deploy; environments define “where and how.”

## 3. Clear Boundary Between Configuration and Logic

The structure separates:

- Configuration → Inside environments/

- Infrastructure logic → Inside modules/

### Why this design?

- Makes the project easy to understand

- Makes modifying an environment safer and more explicit

- Improves long-term maintainability

Operators work in environments; developers work in modules.

## 4. Vault Integration Structured for Security

Vault resources are clearly organized by:

- Secrets (per environment)

- Policies

- Auth backends

- User creation endpoints

Each environment uses a different Vault provider alias (vault_dev, vault_prod) ensuring secrets never mix.

### Why this design?

- Strong environment isolation

- Avoids leaking production secrets into development

- Ensures reproducible, version-controlled Vault configuration

- Makes onboarding new services easier

- The structure reflects real-world Vault operations practice.

## 5. Supports Service Scalability

By modularizing each service and environment:

- Adding new microservices requires only a new module folder

- Creating new environments is as simple as duplicating one folder

- Docker containers and Vault secrets can scale horizontally

### Why this design?

This project can grow without becoming complicated. The structure anticipates more services, more environments, and more Vault paths.

## 6. CI/CD Friendly Layout

This structure is optimized for automated pipelines:

- Each environment can be deployed independently

- Modules can be tested, linted, or validated in isolation

- Terraform plan/apply workflows become predictable

### Why this matters

- Ensures safe production rollout

- Supports GitOps or branch-based deployments

- Easier collaboration among teams

## 7. Team-Friendly, Standardized Structure

The structure is intuitive for:

- DevOps / SRE teams

- Backend engineers

- Security & platform engineers

### Benefits

- Clear ownership of modules

- Predictable environment-specific changes

- Easier onboarding

The directory layout follows patterns used in enterprise Terraform repositories.