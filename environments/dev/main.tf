# -----------------------------------------------------------------------------
# 1. Dev Environment: Resource Groups
# -----------------------------------------------------------------------------
module "resource_group" {
  source = "../../modules/resource_group"

  resource_groups = var.resource_groups
  default_tags    = var.default_tags
}

# -----------------------------------------------------------------------------
# 2. Dev Environment: Azure Container Registry (ACR)
# -----------------------------------------------------------------------------
module "acr" {
  source = "../../modules/acr"

  registries   = var.registries
  default_tags = var.default_tags

  depends_on = [module.resource_group]
}

# -----------------------------------------------------------------------------
# 3. Dev Environment: Azure Kubernetes Service (AKS)
# -----------------------------------------------------------------------------
module "aks" {
  source = "../../modules/aks"

  clusters     = var.clusters
  default_tags = var.default_tags

  depends_on = [module.resource_group]
}

# -----------------------------------------------------------------------------
# 4. Dev Environment: Azure Storage Account
# -----------------------------------------------------------------------------
module "storage_account" {
  source = "../../modules/storage_account"

  storage_accounts = var.storage_accounts
  default_tags     = var.default_tags

  depends_on = [module.resource_group]
}
