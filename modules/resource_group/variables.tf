variable "resource_groups" {
  description = "Map of resource groups to create."
  type = map(object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "default_tags" {
  description = "Default tags to apply to all resource groups."
  type        = map(string)
  default     = {}
}
