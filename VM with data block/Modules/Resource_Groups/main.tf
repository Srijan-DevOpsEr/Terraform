resource "azurerm_resource_group" "Virtual-carrybag" {
  for_each = var.rg_map
  name     = each.value.name
  location = each.value.location

}
