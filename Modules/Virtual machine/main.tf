resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_mod
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "VM_ips"
    subnet_id                     = data.azurerm_subnet.Subnet_data[each.key].id
    private_ip_address_allocation = "Dynamic"
      }
}
data "azurerm_subnet" "Subnet_data" {
  for_each             = var.vm_mod
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
}

data "azurerm_key_vault" "Key_vault" {
  name                = "G18keyvault"
  resource_group_name = "G18Keyvault-RG"
}

data "azurerm_key_vault_secret" "secret_data1" {
  name         = "kashifuser"
  key_vault_id = data.azurerm_key_vault.Key_vault.id
}

data "azurerm_key_vault_secret" "secret_data2" {
  name         = "Kashifpassword"
  key_vault_id = data.azurerm_key_vault.Key_vault.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vm_mod
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.secret_data1.value
  admin_password                  = data.azurerm_key_vault_secret.secret_data2.value
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]

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
