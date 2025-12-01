# Structure Overview 
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