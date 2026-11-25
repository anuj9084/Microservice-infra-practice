locals {
  storage_containers = merge([
    for sa_key, sa in var.storage_accounts : {
      for container_key, container in sa.containers : "${sa_key}/${container_key}" => {
        storage_account_key   = sa_key
        name                  = container.name
        container_access_type = container.container_access_type
      }
    }
  ]...)
}

resource "azurerm_storage_account" "this" {
  for_each = var.storage_accounts

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  account_kind                    = each.value.account_kind
  min_tls_version                 = each.value.min_tls_version
  https_traffic_only_enabled      = each.value.https_traffic_only_enabled
  allow_nested_items_to_be_public = each.value.allow_nested_items_to_be_public
  public_network_access_enabled   = each.value.public_network_access_enabled
  tags                            = merge(var.default_tags, each.value.tags)

  network_rules {
    default_action             = each.value.network_rules.default_action
    bypass                     = each.value.network_rules.bypass
    ip_rules                   = each.value.network_rules.ip_rules
    virtual_network_subnet_ids = each.value.network_rules.virtual_network_subnet_ids
  }
}

resource "azurerm_storage_container" "this" {
  for_each = local.storage_containers

  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.this[each.value.storage_account_key].id
  container_access_type = each.value.container_access_type
}
