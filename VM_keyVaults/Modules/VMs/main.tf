resource "azurerm_key_vault_secret" "sec_password" {
  for_each     = var.Vms
  name         = "${each.value.Vm_name}-Password"
  value        = each.value.value
  key_vault_id = data.azurerm_key_vault.keyvault-data[each.key].id
}
data "azurerm_key_vault" "keyvault-data" {
  for_each            = var.Vms
  name                = each.value.Kv_name
  resource_group_name = each.value.Rg_name
}
data "azurerm_subnet" "data-sub" {
  for_each             = var.Vms
  name                 = each.value.Subnet_name
  virtual_network_name = each.value.Vnet_name
  resource_group_name  = each.value.Rg_name
}

# data "azurerm_key_vault" "Key_vault" {
#   name                = "Srikeyvault"
#   resource_group_name = "kv-rg"
# }

# data "azurerm_key_vault_secret" "sec_password" {
#   name         = "sriuser"
#   key_vault_id = data.azurerm_key_vault.Key_vault.id
# }

# data "azurerm_key_vault_secret" "secret_data2" {
#   name         = "sripassword"
#   key_vault_id = data.azurerm_key_vault.Key_vault.id
# }


resource "azurerm_network_interface" "Nic" {
  for_each            = var.Vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.Rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.data-sub[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "VMs" {
  for_each                        = var.Vms
  name                            = each.value.Vm_name
  resource_group_name             = each.value.Rg_name
  location                        = each.value.location
  size                            = "Standard_F2"
  admin_username                  = "Veripark-user"
  admin_password                  = azurerm_key_vault_secret.sec_password[each.key].value
  network_interface_ids           = [azurerm_network_interface.Nic[each.key].id]
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

