# Production Multi-Environment Terraform Architecture

This repository follows the industry-standard multi-environment Terraform structure.

Shared reusable modules are located under `modules/`, and the environment configuration lives under `environments/dev/`. There is **only one** set of execution files (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and `terraform.tfvars`) located where Terraform commands are executed: in the environment directory.

---

## Directory Layout

```text
D:/K8 Practice/
├── .github/
│   └── workflows/
│       └── ci-cd.yml                # 3-stage DevSecOps CI/CD pipeline
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
│   └── aks/
│       ├── main.tf                  # for_each = var.clusters
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── environments/                    # Environment entrypoints
│   └── dev/
│       ├── .terraform.lock.hcl      # Provider dependency lockfile
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

---

## DevSecOps CI/CD Pipeline

This repository includes a 3-stage GitHub Actions CI/CD & security workflow located in [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml).

### Pipeline Stages

| # | Job / Stage | Tool | Description & Scope |
| :-: | :--- | :--- | :--- |
| **1** | **Security & Validate** (`security`) | **Gitleaks, Aqua Trivy, Terraform** | Scans git history for secrets, runs Trivy IaC config scan (`CRITICAL,HIGH` SARIF upload to GitHub Security), and verifies `terraform fmt` & `terraform validate`. |
| **2** | **Init & Plan** (`plan`) | **Terraform (`azurerm` backend)** | Authenticates to Azure via `AZURE_CREDENTIALS`, initializes remote state, and runs `terraform plan` (or `plan -destroy` when `action=destroy`). |
| **3** | **Apply** (`apply`) | **Terraform (`azurerm` backend)** | Runs on `push` to `main` or manual dispatch (`action != plan`), protected by the GitHub `dev` Environment, to run `terraform apply` (or `destroy`). |

### Pipeline Triggers

- **Push & Pull Requests**: Runs `Security & Validate` and `Init & Plan` on PRs; also runs `Apply` on `push` to `main`.
- **Scheduled Audit**: Runs `Security & Validate` every Monday at 02:00 UTC.
- **Manual Trigger**: Can be dispatched from the GitHub Actions tab (`workflow_dispatch`) with `environment` (`dev`) and `action` (`plan`, `apply`, or `destroy`).

### Required GitHub Configuration (for `plan` & `apply`)

1. **Repository Secret**:
   - `AZURE_CREDENTIALS`: JSON output from `az ad sp create-for-rbac --sdk-auth` (`clientId`, `clientSecret`, `subscriptionId`, `tenantId`).
2. **Repository Variables (or Secrets)**:
   - `TF_STATE_RG`: Resource group containing your Terraform remote state Storage Account.
   - `TF_STATE_STORAGE`: Azure Storage Account name for remote state.
   - `TF_STATE_CONTAINER`: Blob container name for remote state.
3. **GitHub Environment**:
   - Create an environment named `dev` under **Settings > Environments** and configure **Required reviewers** to enforce manual approval before `Apply`.

