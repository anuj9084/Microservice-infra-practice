# -----------------------------------------------------------------------------
# TFLint Configuration
# -----------------------------------------------------------------------------

config {
  module = true
  force  = false
}

# Terraform core ruleset
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# AzureRM provider ruleset
plugin "azurerm" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}
