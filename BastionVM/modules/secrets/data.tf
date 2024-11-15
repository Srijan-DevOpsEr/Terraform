data "azurerm_key_vault" "keyvault-data" {
  for_each = var.secret
  name = each.value.key_name
  resource_group_name = each.value.resource_group_name
}