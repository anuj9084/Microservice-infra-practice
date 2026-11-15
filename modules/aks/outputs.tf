output "cluster_ids" {
  description = "Map of AKS cluster resource IDs."
  value       = { for k, c in azurerm_kubernetes_cluster.this : k => c.id }
}

output "cluster_names" {
  description = "Map of AKS cluster names."
  value       = { for k, c in azurerm_kubernetes_cluster.this : k => c.name }
}

output "kube_config_raw" {
  description = "Map of raw kubeconfig file strings (sensitive)."
  value       = { for k, c in azurerm_kubernetes_cluster.this : k => c.kube_config_raw }
  sensitive   = true
}
