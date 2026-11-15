variable "registries" {
  description = "Map of Azure Container Registries to deploy (Basic or Standard SKU)."
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

variable "default_tags" {
  description = "Default tags to merge with resource tags."
  type        = map(string)
  default     = {}
}
