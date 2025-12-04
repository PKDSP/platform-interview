# ⚙️ Section Overview
- [ ] Design Decisions for the Terraform Project Structure.
- [ ] Main Purpose of This Directory Structure.
- [ ] Why I chose this design.
- [ ] How to Use settings.json for Adding Services or Updating Versions.
- [ ] How code would fit into a CI/CD pipeline.
- [ ] Anything beyond the scope of this task that you would consider when running this code in a real production environment.

## Design Decisions for the Terraform Project Structure


Overall, this architecture ensures that the infrastructure remains modular, secure, reproducible, and easy to extend as new services and environments are added.

```
├── Readme.md
├── environments
│   ├── development
│   │   ├── config
│   │   │   └── settings.json      # Environment-specific settings
│   │   ├── main.tf                # Entry point for dev deployment
│   │   └── variables.tf           # Dev-specific variables
│   ├── production
│   │   ├── config
│   │   │   └── settings.json      # Environment-specific settings
│   │   ├── main.tf                # Entry point for production deployment
│   │   └── variables.tf           # Production-specific variables
│   └── staging
│       ├── config
│       │   └── settings.json      # Environment-specific settings
│       ├── main.tf                # Entry point for Staging deployment
│       └── variables.tf           # Production-specific variables
├── modules                        # Reusable infrastructure components
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
│   ├── services                  # Backed Microservices 
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

## Main Purpose of This Directory Structure

This design follows a modular, environment-specific Terraform architecture where:

### 1. Each environment (dev/staging/prod) is fully isolated

The environments/ directory provides separation of state, configuration, and variables for each environment.
This ensures:

- No accidental cross-deployment

- Independent lifecycle and updates

- Environment-specific overrides (settings.json, variables.tf)

### 2. Reusable modules implement the actual infrastructure

The modules/ folder contains:

- common — shared foundational resources

- frontend — UI-related infra components

- services — backend or microservice infra

- vault — secrets/identity-related infra

This allows:

- Clean abstraction boundaries

- Reusable building blocks

- Easier testing and independent modifications

### 3. Environments consume modules instead of duplicating code

Each environment uses its own main.tf but always references modules from modules/*.

This ensures:

- DRY (Don’t Repeat Yourself)

- Consistency across environments

- Faster onboarding and reduced errors

### 4. Providers are centralized for consistency

providers.tf at the root defines provider versions and global settings, ensuring:

- Uniform provider configuration

- Reduced drift across environments

- Easy updates


## Why I chose this design

I selected this structure to balance clarity, reusability, and environment isolation, while keeping the solution aligned with real-world Terraform best practices. The design ensures that:

### 1. Environments are completely isolated
Each environment (development, staging, production) has its own directory with its own configuration and state. This avoids unintended changes and allows safe, independent deployments.

### 2. Modules implement infrastructure once and reuse it everywhere
By defining common, frontend, services, and vault modules, I avoid repeating similar Terraform code in every environment. This makes the design clean, consistent, and easier to maintain over time.

### 3. The abstractions are clear and future-proof
Each module maps to a logical domain area (shared resources, frontend, services, vault/security). This mirrors how infrastructure is typically organized in larger systems and makes the design easy to extend when new components or services are added.

### 4. The solution is simple enough for the scope of the exercise
While modular, the structure is not overly complex. It focuses on clarity and maintainability within a limited-time technical assessment, without unnecessary layers or abstractions.

### 5. Provider management is centralized for consistency
Keeping provider configurations at the root prevents drift, makes version upgrades easier, and ensures all modules behave consistently.


## How to Use settings.json for Adding Services or Updating Versions

### 1. Adding a New Service

- Open the relevant environment’s config/settings.json (e.g., environments/development/config/settings.json).

- Add a new service entry under services section:

```
"notifications": {
  "image": "form3tech-oss/platformtest-notifications",
  "port": 8084,
  "username": "notifications",
  "password": "new-uuid-password",
  "version": "latest"
}
```

Reference the new service in the corresponding Terraform module (services/main.tf) by mapping the JSON attributes to the module inputs.

### 2. Updating a Service Version

- Locate the service in settings.json.

- Update the "version" field to the desired Docker image tag:

```
"account": {
  "image": "form3tech-oss/platformtest-account",
  "port": 8081,
  "username": "account",
  "password": "965d3c27-9e20-4d41-91c9-61e6631870e7",
  "version": "v2.1.0"
}
```

- Apply Terraform to deploy the updated version:

```
cd environments/development
terraform init
terraform plan
terraform apply
```

### 3. Adding a New Environment

- Copy an existing environment directory (development) to create a new one (qa or uat).

- Update settings.json with environment-specific values.

- Apply Terraform in the new environment directory.

### Benefits

- Centralized Configuration: All environment-specific parameters in one JSON file.

- Easy Version Updates: Simply change the "version" for a service.

- Extensible: New services or environments can be added without changing module code.

- Consistency: Enforces a standard structure across all environments.


##  How code would fit into a CI/CD pipeline(Pipeline Integration).

The pipeline is triggered based on the branch pushed. It automatically selects the correct environments/ directory to run Terraform commands, ensuring clear separation of environments.

### 1. Feature Phase (feature/*)
- Trigger: Push or Pull Request to develop.

- Scope: environments/development

- Actions:
```
  - terraform fmt -check (Linting)

  - terraform validate (Syntax check)

  - terraform plan (Generates a speculative plan to show what would happen).
```
### 2. Integration Phase (develop)
- Trigger: Merge into develop.

- Scope: environments/development and environments/staging

- Actions:

```
  - Apply Dev: terraform apply -auto-approve targeting the Development folder.

  - Smoke Tests: Run integration tests against Dev.

  - Apply Staging: If Dev succeeds, terraform apply -auto-approve targeting the Staging folder.
```

### 3. Release Phase (release/*)
- Trigger: Creation of a release branch.

- Scope: environments/production

- Actions:

```
  - terraform plan targeting the Production folder.

  - The plan is saved as an artifact for review by the DevOps team. Deployment is linked to a Git tag.
```

### 4. Production Phase (main)
- Trigger: Merge release/* or hotfix/* into main. Create Tag (e.g., v1.0.0) from main branch

- Scope: environments/production

- Actions:

```
  - Gate: Manual approval required (optional but recommended).

  - Apply: terraform apply targeting the Production folder. This step only runs if the merge commit is associated with a tagged version (e.g., v1.0.0).
  ```

## Anything beyond the scope of this task that you would consider when running this code in a real production environment.
For a real production environment, the following non-Terraform aspects are mandatory for stability, security, and compliance:

### 1. Security Enhancements
- Eliminate Static Tokens: Replace all hardcoded Vault tokens with Cloud Provider IAM/OIDC.

- Dynamic Secrets: Implement Vault Dynamic Secrets (e.g., for databases) to generate expiring credentials on-demand instead of provisioning static passwords.

- Least Privilege: Enforce strict Vault ACLs ensuring each service can only read its specific secret path.

### 2. Stability & State Management
- Remote State/Locking: Configure a robust remote backend (S3, GCS, etc.) with State Locking to prevent concurrent state file corruption.

### 3. Scalability & Monitoring
- Orchestration: Migrate from basic docker_container resources to a platform like Kubernetes (EKS/AKS/GKE) or AWS ECS/Fargate.

- Observability: Implement centralized logging and monitoring (ELK/DataDog) and stream Vault Audit Logs off the local filesystem for compliance.

- Testing: Integrate Terratest or similar frameworks to run functional tests against test-deployed infrastructure before promoting changes.
