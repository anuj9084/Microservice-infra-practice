output "ids" {
  description = "Map of resource group IDs."
  value       = { for k, rg in azurerm_resource_group.this : k => rg.id }
}

output "names" {
  description = "Map of resource group names."
  value       = { for k, rg in azurerm_resource_group.this : k => rg.name }
}
