resource "azurerm_subnet" "sub" {
   for_each = var.vms
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name =each.value.vnet_name
  address_prefixes     =each.value.address_prefixes
}

resource "azurerm_subnet" "sub2" {
  for_each = var.bas
  name                 = "AzureBastionSubnet"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes
}