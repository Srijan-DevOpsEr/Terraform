data "azurerm_subnet" "Subnet_data" {
  for_each             = var.nsgnic_mod
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}
data "azurerm_network_security_group" "nsg_data" {
  for_each            = var.nsgnic_mod
  name                = each.value.nsg_name
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_subnet_network_security_group_association" "nsgnic" {
  for_each                  = var.nsgnic_mod
  subnet_id                 = data.azurerm_subnet.Subnet_data[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg_data[each.key].id
}
