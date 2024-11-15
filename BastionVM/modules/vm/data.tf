data "azurerm_network_interface" "nic-data" {
  for_each            = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault" "keyvault-data" {
  name                = "Bastionkvault"
  resource_group_name = "Bastion-rg"
}

data "azurerm_key_vault_secret" "username-data" {
  name         = "Bastion-username"
  key_vault_id = data.azurerm_key_vault.keyvault-data.id
}
data "azurerm_key_vault_secret" "password-data" {
  name         = "Bastion-password"
  key_vault_id = data.azurerm_key_vault.keyvault-data.id
}
