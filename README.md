# Production Multi-Environment Terraform Architecture

This repository follows the industry-standard multi-environment Terraform structure.

Shared reusable modules are located under `modules/`, and the environment configuration lives under `environments/dev/`. There is **only one** set of execution files (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and `terraform.tfvars`) located where Terraform commands are executed: in the environment directory.

---

## Directory Layout

```text
D:/K8 Practice/
├── modules/                         # Reusable child modules
│   ├── resource_group/
│   │   ├── main.tf                  # for_each = var.resource_groups
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── acr/
│   │   ├── main.tf                  # for_each = var.registries
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   ├── aks/
│       ├── main.tf                  # for_each = var.clusters
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│   └── storage_account/
│       ├── main.tf                  # for_each = var.storage_accounts
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── environments/                    # Environment entrypoints
│   └── dev/
│       ├── .terraform.lock.hcl      # Provider dependency lockfile
│       ├── backend.tf               # AzureRM remote state backend block
│       ├── main.tf                  # Calls ../../modules/*
│       ├── variables.tf             # Input variables schema
│       ├── outputs.tf               # Environment outputs
│       ├── versions.tf              # Provider & version constraints
│       └── terraform.tfvars         # Dev environment values
├── .gitignore
├── LICENSE
└── README.md
```

---

## How to Run

Navigate into the environment folder:

```powershell
cd environments/dev
terraform init
terraform plan
terraform apply
```

To add future environments (such as `prod` or `qa`), simply add a folder under `environments/` (e.g. `environments/prod`) and call the same reusable `modules/`.

