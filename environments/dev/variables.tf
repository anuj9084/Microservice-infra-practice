variable "resource_groups" {
  description = "Map of Azure Resource Groups to manage for dev environment."
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
  default = {}
}

variable "registries" {
  description = "Map of Azure Container Registries to deploy for dev environment."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "Standard")
    admin_enabled       = optional(bool, false)
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "clusters" {
  description = "Nested map of AKS clusters to deploy for dev environment."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    dns_prefix          = optional(string, null)
    sku_tier            = optional(string, "Free")

    # Nested Map / Object for Default Node Pool
    default_node_pool = object({
      name            = optional(string, "system")
      vm_size         = optional(string, "Standard_D2s_v4")
      node_count      = optional(number, 2)
      os_disk_size_gb = optional(number, 128)
      tags            = optional(map(string), {})
    })

    # Optional Nested Object for Dynamic Block
    network_profile = optional(object({
      network_plugin = optional(string, "kubenet")
    }), null)

    tags = optional(map(string), {})
  }))
  default = {}
}

variable "storage_accounts" {
  description = "Map of Azure Storage Accounts and optional blob containers to deploy for dev environment."
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    account_tier                    = optional(string, "Standard")
    account_replication_type        = optional(string, "LRS")
    account_kind                    = optional(string, "StorageV2")
    min_tls_version                 = optional(string, "TLS1_2")
    https_traffic_only_enabled      = optional(bool, true)
    allow_nested_items_to_be_public = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    network_rules = optional(object({
      default_action             = optional(string, "Deny")
      bypass                     = optional(list(string), ["AzureServices"])
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), {})
    containers = optional(map(object({
      name                  = string
      container_access_type = optional(string, "private")
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags to apply to dev environment resources."
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
