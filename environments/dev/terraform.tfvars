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
    admin_enabled       = true
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
      vm_size    = "Standard_D2s_v5"
      node_count = 2
    }

    # Optional dynamic block for network profile
    network_profile = {
      network_plugin = "kubenet"
    }
  }
}
