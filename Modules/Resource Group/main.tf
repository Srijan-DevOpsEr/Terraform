resource "azurerm_resource_group" "RG" {
  for_each = var.rg_mod
  name     = each.value.name
  location = each.value.location
}
