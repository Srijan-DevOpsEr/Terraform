resource "azurerm_virtual_network" "Vnet" {
    for_each = var.vnet
       name = each.value.name
    location = each.value.location
    resource_group_name = each.value.Rg_name
    address_space = each.value.address_space
  
}