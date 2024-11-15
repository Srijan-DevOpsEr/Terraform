# data "azurerm_key_vault" "Key_vault" {
#   name                = "G18keyvault"
#   resource_group_name = "G18Keyvault-RG"
# }

# data "azurerm_key_vault_secret" "secret_data1" {
#   name         = "kashifuser"
#   key_vault_id = data.azurerm_key_vault.Key_vault.id
# }

# data "azurerm_key_vault_secret" "secret_data2" {
#   name         = "kashifpassword"
#   key_vault_id = data.azurerm_key_vault.Key_vault.id
# }
