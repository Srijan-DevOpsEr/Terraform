resource "azurerm_subnet" "Virtual-subnet" {
  for_each = var.sub
  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
}