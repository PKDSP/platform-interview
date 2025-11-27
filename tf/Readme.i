.
├── providers.tf
│
├── modules/
│   ├── resource_modules/
│   │   ├── app_service/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   └── vault_secrets/
│   │       ├── main.tf
│   │       └── variables.tf
│   │
│   └── service_definitions/
│       ├── account/
│       │   ├── main.tf
│       │   └── variables.tf
│       ├── gateway/
│       │   ├── main.tf
│       │   └── variables.tf
│       ├── payment/
│       │   ├── main.tf
│       │   └── variables.tf
│       └── frontend/
│           ├── main.tf
│           └── variables.tf
│
└── environments/
    ├── dev/
    │   ├── main.tf
    │   └── variables.tf
    └── prod/
        ├── main.tf
        └── variables.tf                          # (Optional) Root file for global settings (e.g., required providers)

├── providers.tf                  # Global provider definitions
│
├── modules/
│   ├── resource_modules/
│   │   ├── app_service/          # Base Docker logic
│   │   │   └── ...
│   │   └── vault_secrets/        # Base Vault logic
│   │       └── ...
│   │
│   └── service_deployer/         # Single module to deploy ALL services (SSOT)
│       └── ... (main.tf, variables.tf)
│
└── environments/
    ├── dev/
    │   ├── main.tf               # Deployment logic (uses for_each)
    │   ├── variables.tf          # Version/Secret variables
    │   └── services.tf           # Service definitions (SSOT config map)
    ├── staging/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── services.tf
    └── prod/
        ├── main.tf
        ├── variables.tf
        └── services.tf




├── providers.tf                  # Global provider definitions (Vault, Docker, Random)
│
├── global_config/                # Global Single Source of Truth (SSOT) for Service Metadata
│   └── service_metadata.tf       # Defines standard image names, Vault flags, and default ports
│
├── modules/
│   ├── resource_modules/
│   │   ├── app_service/          # Base Docker deployment logic
│   │   │   └── main.tf
│   │   └── vault_secrets/        # Base Vault logic (secret/policy/user creation)
│   │       └── main.tf
│   │
│   └── service_deployer/         # Module remains the deployment driver
│       └── main.tf
│
└── environments/
    ├── dev/
    │   ├── main.tf               # Deployment logic (uses for_each and locals)
    │   └── variables.tf          # Environment-specific configuration (Versions, Secrets, Network)
    ├── staging/
    │   ├── main.tf
    │   └── variables.tf
    └── prod/
        ├── main.tf
        └── variables.tf


├── providers.tf
│
├── global_config/
│   └── service_metadata.tf
│
├── modules/
│   ├── resource_modules/
│   │   ├── app_service/
│   │   │   └── main.tf
│   │   └── vault_secrets/
│   │       └── main.tf
│   │
│   ├── service_deployer/
│   │   └── main.tf
│   │
│   └── environment_config/
│       └── main.tf
│
└── environments/
    ├── dev/
    │   ├── main.tf
    │   └── variables.tf
    ├── staging/
    │   ├── main.tf
    │   └── variables.tf
    └── prod/
        ├── main.tf
        └── variables.tf


├── providers.tf                  # Global Providers (including vault.config)
├── types.tf                      # NEW: Central definition of the Service Config Schema
│
├── global_config/
│   └── main.tf                   # Module that exports static service metadata
│
├── modules/
│   ├── resource_modules/
│   │   ├── app_service/
│   │   │   └── main.tf
│   │   └── vault_secrets/
│   │       └── main.tf
│   │
│   ├── service_deployer/
│   │   └── main.tf
│   │
│   └── environment_config/       # The core deployment logic abstraction
│       └── main.tf
│
└── environments/
    ├── dev/
    │   ├── main.tf               # Calls global_config module
    │   └── variables.tf          # Local config (references types.tf schema)
    ├── staging/
    │   ├── main.tf
    │   └── variables.tf
    └── prod/
        ├── main.tf
        └── variables.tf


.
├── providers.tf                  # Global Providers (Vault, Docker, Random, Config aliases)
├── types.tf                      # Central definition of the Service Config Schema
│
├── global_config/
│   └── main.tf                   # Module: Exports static service metadata (SSOT)
│
├── modules/
│   ├── resource_modules/         # Low-level infrastructure resources
│   │   ├── app_service/
│   │   │   └── main.tf           # Docker container deployment logic
│   │   └── vault_secrets/
│   │       └── main.tf           # Vault secret, policy, and user creation
│   │
│   ├── service_deployer/         # Mid-level module: Instantiates one service and its secrets
│   │   └── main.tf
│   │
│   └── environment_config/       # High-level abstraction: The core 'for_each' deployment logic
│       └── main.tf
│
└── environments/                 # Environment Entry Points (Minimal Logic)
    ├── dev/
    │   ├── main.tf               # Calls global_config and environment_config modules
    │   ├── variables.tf          # Local configuration (Versions, Ports, Network)
    │   └── backend.tf            # Explicit state configuration (local for dev)
    ├── staging/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── backend.tf            # Explicit state configuration (remote S3/GCS)
    └── prod/
        ├── main.tf
        ├── variables.tf
        └── backend.tf            # Explicit state configuration (secure remote S3/GCS with locking)