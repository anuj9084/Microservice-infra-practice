output "ids" {
  description = "Map of container registry resource IDs."
  value       = { for k, acr in azurerm_container_registry.this : k => acr.id }
}

output "login_servers" {
  description = "Map of container registry login server hostnames."
  value       = { for k, acr in azurerm_container_registry.this : k => acr.login_server }
}

output "admin_usernames" {
  description = "Map of admin usernames (if admin_enabled is true)."
  value       = { for k, acr in azurerm_container_registry.this : k => acr.admin_username if acr.admin_enabled }
  sensitive   = true
}

output "admin_passwords" {
  description = "Map of admin passwords (if admin_enabled is true)."
  value       = { for k, acr in azurerm_container_registry.this : k => acr.admin_password if acr.admin_enabled }
  sensitive   = true
}
