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
      vm_size         = optional(string, "Standard_D2s_v5")
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

variable "default_tags" {
  description = "Default tags to apply to dev environment resources."
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
