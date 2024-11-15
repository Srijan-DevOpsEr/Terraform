resource "azurerm_subnet" "kvsubnet" {
    for_each = var.subs
        name = each.value.name
       resource_group_name = each.value.Rg_name
       virtual_network_name = each.value.Vnet_name
       address_prefixes = each.value.address_prefixes
}