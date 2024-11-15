data "azurerm_subnet" "subnet1" {
  name                 = "backend"
  virtual_network_name = "Vnetwork"
  resource_group_name  = "Dev_rg"
}

output "subnet_id" {
  value = data.azurerm_subnet.subnet1.id
}