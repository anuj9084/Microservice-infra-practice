# =============================================================================
# Dev Environment Configuration (environments/dev/terraform.tfvars)
# =============================================================================

default_tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "DevTeam"
}

# 1. Dev Resource Group
resource_groups = {
  dev_rg = {
    name     = "rg-k8s-dev-eastus"
    location = "eastus"
  }
}

# 2. Dev Container Registry (ACR)
registries = {
  dev_acr = {
    name                = "acrdevk8s01"
    resource_group_name = "rg-k8s-dev-eastus"
    location            = "eastus"
    sku                 = "Basic"
    admin_enabled       = false
  }
}

# 3. Dev Kubernetes Cluster (AKS)
clusters = {
  dev_aks = {
    name                = "aks-dev-eastus-01"
    resource_group_name = "rg-k8s-dev-eastus"
    location            = "eastus"
    dns_prefix          = "aks-dev"
    sku_tier            = "Free"

    # Nested map for the default node pool
    default_node_pool = {
      name       = "system"
      vm_size    = "Standard_D2s_v4"
      node_count = 2
    }

    # Optional dynamic block for network profile
    network_profile = {
      network_plugin = "kubenet"
    }
  }
}

# 4. Dev Storage Account
storage_accounts = {
  dev_storage = {
    name                     = "stdevk8s01"
    resource_group_name      = "rg-k8s-dev-eastus"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"

    containers = {
      app_data = {
        name                  = "appdata"
        container_access_type = "private"
      }
    }
  }
}
