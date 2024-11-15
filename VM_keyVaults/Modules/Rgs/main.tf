resource "azurerm_resource_group" "kvRgs" {
  for_each = var.Rgs
  name     = each.value.Rg_name
  location = each.value.location
}

