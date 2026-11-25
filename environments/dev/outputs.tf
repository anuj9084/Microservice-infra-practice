# -----------------------------------------------------------------------------
# Dev Environment Outputs
# -----------------------------------------------------------------------------
output "resource_group_ids" {
  description = "Resource Group IDs for dev environment"
  value       = module.resource_group.ids
}

output "acr_login_servers" {
  description = "ACR Login Server hostnames for dev environment"
  value       = module.acr.login_servers
}

output "aks_cluster_names" {
  description = "AKS Cluster Names for dev environment"
  value       = module.aks.cluster_names
}

output "aks_kube_config_raw" {
  description = "Raw kubeconfig file strings for dev environment (sensitive)"
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "storage_account_ids" {
  description = "Storage Account IDs for dev environment"
  value       = module.storage_account.ids
}

output "storage_account_primary_blob_endpoints" {
  description = "Storage Account primary blob endpoints for dev environment"
  value       = module.storage_account.primary_blob_endpoints
}
