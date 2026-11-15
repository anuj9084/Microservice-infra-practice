# -----------------------------------------------------------------------------
# Azure Kubernetes Service Cluster (Simple Version)
# -----------------------------------------------------------------------------
resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.clusters

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = coalesce(each.value.dns_prefix, replace(each.value.name, "_", "-"))
  sku_tier            = each.value.sku_tier
  tags                = merge(var.default_tags, each.value.tags)

  # Minimal Azure requirement: system-assigned identity
  identity {
    type = "SystemAssigned"
  }

  # Nested map configuration for primary node pool
  default_node_pool {
    name            = each.value.default_node_pool.name
    vm_size         = each.value.default_node_pool.vm_size
    node_count      = each.value.default_node_pool.node_count
    os_disk_size_gb = each.value.default_node_pool.os_disk_size_gb
    tags            = merge(var.default_tags, each.value.default_node_pool.tags)
  }

  # Dynamic Block: rendered only if network_profile is specified
  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin = network_profile.value.network_plugin
    }
  }
}
