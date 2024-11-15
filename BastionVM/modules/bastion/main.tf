resource "azurerm_bastion_host" "bastion" {
  for_each            = var.bas
  name                = each.value.bas_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = each.value.ip_name
    subnet_id            = data.azurerm_subnet.bas-sub-data[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pip-data[each.key].id
  }
}
data "azurerm_public_ip" "pip-data" {
  for_each = var.bas
  name = each.value.pip_name
   resource_group_name =each.value.resource_group_name
}

data "azurerm_subnet" "bas-sub-data" {
  for_each = var.bas
  name = "AzureBastionSubnet"
  resource_group_name = each.value.resource_group_name
  virtual_network_name = each.value.vnet_name
}

# resource "azurerm_public_ip" "pip" {
#     for_each = var.bas
#   name                = each.value.pip_name
#   location            = each.value.location
#   resource_group_name = each.value.resource_group_name
#   allocation_method   = each.value.allocation_method
#   sku                 = each.value.sku
# }