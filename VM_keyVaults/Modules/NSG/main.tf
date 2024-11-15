data "azurerm_subnet" "Subnet_data" {
  for_each             = var.Nsg
  name                 = each.value.subnet_name
  resource_group_name  = each.value.Rg_name
  virtual_network_name = each.value.Vnet_name
}
resource "azurerm_subnet_network_security_group_association" "Nsga" {
      for_each                  = var.Nsg
  subnet_id                 = data.azurerm_subnet.Subnet_data[each.key].id
  network_security_group_id = azurerm_network_security_group.NSG[each.key].id
}
resource "azurerm_network_security_group" "NSG" {
  for_each            = var.Nsg
  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = each.value.Rg_name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
