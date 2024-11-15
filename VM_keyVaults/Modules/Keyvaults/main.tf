resource "azurerm_key_vault" "kv" {
  for_each                  = var.Kvault
  name                        = each.value.Kv_name
  location                    = each.value.location
  resource_group_name         = each.value.Rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [ "Get" ]

    secret_permissions = ["Get","List","Set","Recover","Delete","Restore","Purge","Backup"]

    storage_permissions = ["Get", ]
  }
}
