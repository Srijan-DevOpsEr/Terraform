# data "azurerm_public_ip" "pip-data" {
#   for_each = var.bas
#   name = each.value.pip_name
#    resource_group_name =each.value.resource_group_name
# }

# data "azurerm_subnet" "bas-sub-data" {
#   for_each = var.bas
#   name = "AzureBastionSubnet"
#   resource_group_name = each.value.resource_group_name
#   virtual_network_name = each.value.vnet_name
# }