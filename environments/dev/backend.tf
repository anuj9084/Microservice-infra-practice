# -----------------------------------------------------------------------------
# Remote State Backend Configuration (Azure Storage)
# -----------------------------------------------------------------------------
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev-eastus"
    storage_account_name = "sttfstatedev01"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
