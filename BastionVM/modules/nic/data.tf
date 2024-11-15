data "azurerm_subnet" "vm-sub-data" {
  for_each = var.vms
  name =each.value.subnet_name
  resource_group_name =each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
}