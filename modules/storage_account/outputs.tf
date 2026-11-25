output "ids" {
  description = "Map of storage account resource IDs."
  value       = { for k, sa in azurerm_storage_account.this : k => sa.id }
}

output "names" {
  description = "Map of storage account names."
  value       = { for k, sa in azurerm_storage_account.this : k => sa.name }
}

output "primary_blob_endpoints" {
  description = "Map of storage account primary blob endpoints."
  value       = { for k, sa in azurerm_storage_account.this : k => sa.primary_blob_endpoint }
}

output "container_ids" {
  description = "Map of storage container resource IDs."
  value       = { for k, c in azurerm_storage_container.this : k => c.id }
}
