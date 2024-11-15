
variable "stg_map" {
  type = map(any)

}
resource "azurerm_storage_account" "STG" {
  depends_on               = [azurerm_resource_group.RG]
  for_each                 = var.stg_map
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type

    tags = {
        environment = each.value.environment
    }
}