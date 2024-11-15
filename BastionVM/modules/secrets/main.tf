resource "azurerm_key_vault_secret" "secret" {
  for_each = var.secret
  name         = each.value.secret_name
  value        = random_password.password[each.key].result
  key_vault_id = data.azurerm_key_vault.keyvault-data[each.key].id
  }

resource "random_password" "password" {
  for_each = var.secret
  length           = each.value.length
  special          = true
  override_special = "!#$%&*:?"
  min_lower = 1
  min_upper = 1
  min_numeric = 1
}