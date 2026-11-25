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
│   └── aks/
│       ├── main.tf                  # for_each = var.clusters
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── environments/                    # Environment entrypoints
│   └── dev/
│       ├── main.tf                  # Calls ../../modules/*
│       ├── variables.tf             # Input variables schema
│       ├── outputs.tf               # Environment outputs
│       ├── versions.tf              # Provider & version constraints
│       └── terraform.tfvars         # Dev environment values
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

## DevSecOps Security Scanning Pipeline

This repository includes a multi-stage GitHub Actions security workflow located in [`.github/workflows/security-scan.yml`](file:///D:/K8 Practice/.github/workflows/security-scan.yml).

### Scanning Stages

| # | Security Stage | Tool | Description & Scope |
| :-: | :--- | :--- | :--- |
| **1** | **Secret Scanning** | **Gitleaks** | Scans Git commit history and PRs for hardcoded passwords, private keys, API keys, and Azure credentials. |
| **2** | **IaC & Workflow Compliance** | **Checkov** | Scans Terraform & GitHub Actions workflows against CIS benchmarks, Azure security best practices, and policy compliance. |
| **3** | **Misconfig & Exposure Scan** | **Aqua Trivy** | Scans IaC manifests and configs for security misconfigurations and insecure defaults. |
| **4** | **Terraform Lint & Validate** | **Terraform CLI & TFLint** | Verifies Terraform formatting (`fmt`), syntax/module validity (`validate`), and enforces AzureRM provider rules via `tflint-ruleset-azurerm`. |
| **5** | **Quality Gate & Scorecard** | **GitHub Actions Summary** | Publishes a unified security scorecard to the Job Summary and aggregates SARIF reports into the GitHub Security tab. |

### Pipeline Triggers

- **Push & Pull Requests**: Triggers on code changes targeting `main`.
- **Scheduled Audit**: Automatic weekly audit every Monday at 02:00 UTC.
- **Manual Trigger**: Can be dispatched on-demand from the GitHub Actions tab (`workflow_dispatch`).

