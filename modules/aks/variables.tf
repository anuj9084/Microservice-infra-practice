variable "clusters" {
  description = "Nested map of AKS clusters to deploy."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    dns_prefix          = optional(string, null)
    sku_tier            = optional(string, "Free")

    # Nested Map / Object: Default Node Pool configuration
    default_node_pool = object({
      name            = optional(string, "system")
      vm_size         = optional(string, "Standard_D2s_v4")
      node_count      = optional(number, 2)
      os_disk_size_gb = optional(number, 128)
      tags            = optional(map(string), {})
    })

    # Optional Nested Object: Network Profile for Dynamic Block
    network_profile = optional(object({
      network_plugin = optional(string, "kubenet") # "kubenet" or "azure"
    }), null)

    tags = optional(map(string), {})
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags to merge with AKS cluster tags."
  type        = map(string)
  default     = {}
}
