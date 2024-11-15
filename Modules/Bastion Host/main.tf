data "azurerm_subnet" "Subnet_bh" {
  for_each             = var.bastion_mod
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

resource "azurerm_public_ip" "PIP" {
  for_each            = var.bastion_mod
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
   allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_bastion_host" "BH" {
  for_each            = var.bastion_mod
  name                = each.value.bastion_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "bhconfiguration"
    subnet_id            = data.azurerm_subnet.Subnet_bh[each.key].id
    public_ip_address_id = azurerm_public_ip.PIP[each.key].id
  }
}
