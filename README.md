# Production Multi-Environment Terraform Architecture

This repository follows the industry-standard multi-environment Terraform structure.

Shared reusable modules are located under `modules/`, and the environment configuration lives under `environments/dev/`. There is **only one** set of execution files (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and `terraform.tfvars`) located where Terraform commands are executed: in the environment directory.

---

## Directory Layout

```text
D:/K8 Practice/
├── .github/
│   └── workflows/
│       └── ci-security.yml          # DevSecOps CI/CD pipeline
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

This repository includes a GitHub Actions CI/CD & security workflow located in [`.github/workflows/ci-security.yml`](.github/workflows/ci-security.yml).

### Pipeline Stages

| # | Job / Stage | Tool | Description & Scope |
| :-: | :--- | :--- | :--- |
| **1** | **Security Scan & Validate** (`security-and-validate`) | **Gitleaks, Aqua Trivy, Terraform** | Scans git history for secrets, runs Trivy IaC config scan (`CRITICAL,HIGH` SARIF upload to GitHub Security), and verifies `terraform fmt` & `terraform validate`. |
| **2** | **Terraform Deploy** (`terraform`) | **Terraform (`azurerm` backend)** | Initializes remote state and runs `terraform plan` (on PRs or `action=plan`), `terraform apply` (on `push` to `main` or `action=apply`), or `terraform destroy` (`action=destroy`). |
| **3** | **Build & Deploy to AKS** (`deploy-aks`) | **Azure CLI, Docker, kubectl / Helm** | Optional stage on `push` to `main` or `action=apply`: builds & pushes an image to ACR if `Dockerfile` exists, and deploys `k8s/`, `manifests/`, or `charts/` to AKS if present. |

### Pipeline Triggers

- **Push & Pull Requests**: Runs `Security Scan & Validate` and `Terraform Deploy` (`plan` on PRs; `apply` + optional `Build & Deploy to AKS` on `push` to `main`).
- **Scheduled Audit**: Runs `Security Scan & Validate` every Monday at 02:00 UTC.
- **Manual Trigger**: Can be dispatched from the GitHub Actions tab (`workflow_dispatch`) with `environment` (`dev`) and `action` (`plan`, `apply`, or `destroy`).

### Required GitHub Configuration (for `terraform` & `deploy-aks`)

1. **Repository Secret**:
   - `AZURE_CREDENTIALS`: JSON output from `az ad sp create-for-rbac --sdk-auth` (`clientId`, `clientSecret`, `subscriptionId`, `tenantId`).
2. **Repository Variables (or Secrets)**:
   - `TF_STATE_RG`: Resource group containing your Terraform remote state Storage Account.
   - `TF_STATE_STORAGE`: Azure Storage Account name for remote state.
   - `TF_STATE_CONTAINER`: Blob container name for remote state.
3. **GitHub Environment**:
   - Create an environment named `dev` under **Settings > Environments** (referenced by both `terraform` and `deploy-aks`). Note: if you restrict `dev` to `main` or require reviewers, PR `plan` runs in `terraform` will also be subject to those environment rules.

