data "azurerm_subnet" "data_sub" {
for_each = var.bastion_host
name                 = each.value.BHsub_name
virtual_network_name = each.value.Vnet_name
resource_group_name  = each.value.Rg_name
address_prefixes     = each.value.address_prefixes
}

resource "azurerm_bastion_host" "Bast" {
for_each = var.bastion_host
name                 = each.value.Bastion_name
location            = each.value.location
resource_group_name  = each.value.Rg_name

ip_configuration {
name                 = "configuration"
subnet_id            = data.azurerm_subnet.data_sub.id
public_ip_address_id = azurerm_public_ip.PIP.id
}
}

resource "azurerm_public_ip" "PIP" {
for_each = var.bastion_host
name                = each.value.pip_name
resource_group_name = each.value.Rg_name
location            = each.value.location
allocation_method   = "Static"
sku                 = "Standard"
}