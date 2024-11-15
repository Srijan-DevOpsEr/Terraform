resource "azurerm_resource_group" "Rgs" {
  name     = "BastionRG"
  location = "japaneast"
}
variable "Vms" {

}

resource "azurerm_virtual_network" "Vns" {
  depends_on          = [azurerm_resource_group.Rgs]
  name                = "Bastion_Vnet"
  location            = azurerm_resource_group.Rgs.location
  resource_group_name = azurerm_resource_group.Rgs.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subs" {
  depends_on           = [azurerm_virtual_network.Vns,azurerm_resource_group.Rgs]
  for_each             = var.Vms
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_resource_group.Rgs.name
  virtual_network_name = azurerm_virtual_network.Vns.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_interface" "nic" {
  depends_on          = [azurerm_subnet.subs]
  for_each            = var.Vms
  name                = each.value.nic_name
  resource_group_name = azurerm_resource_group.Rgs.name
  location            = azurerm_resource_group.Rgs.location
  ip_configuration {
    name                          = "ipc"
    subnet_id                     = data.azurerm_subnet.datasub[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_public_ip" "PIP" {
  depends_on = [azurerm_resource_group.Rgs]

  name                = "Bastion-pip"
  resource_group_name = azurerm_resource_group.Rgs.name
  location            = azurerm_resource_group.Rgs.location
  allocation_method   = "Static"

}
resource "azurerm_linux_virtual_machine" "Vm" {
  depends_on = [azurerm_subnet.subs, azurerm_key_vault_secret.KVSec, azurerm_network_interface.nic]

  for_each                        = var.Vms
  name                            = each.value.Vmname
  location                        = azurerm_resource_group.Rgs.location
  resource_group_name             = azurerm_resource_group.Rgs.name
  size                            = "Standard_F2"
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]
  admin_username                  = data.azurerm_key_vault_secret.username.value
  admin_password                  = data.azurerm_key_vault_secret.pwd.value
  disable_password_authentication = "false"
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

data "azurerm_subnet" "datasub" {
  for_each             = var.Vms
  name                 = each.value.subnet_name
  virtual_network_name = "Bastion_Vnet"
  resource_group_name  = "BastionRG"
}


data "azurerm_key_vault" "sec" {
  name                = "scrt"
  resource_group_name = "BastionRG"
}
data "azurerm_key_vault_secret" "username" {

  name         = "Bastion-username"
  key_vault_id = data.azurerm_key_vault.sec.id
}
data "azurerm_key_vault_secret" "pwd" {

  name         = "Bastion-Password"
  key_vault_id = data.azurerm_key_vault.sec.id
}

resource "azurerm_subnet" "BastSubnet" {
  depends_on           = [azurerm_linux_virtual_machine.Vm]
  name                 = "AzureBastionSubnet"
  resource_group_name  = "BastionRG"
  virtual_network_name = "japaneast"
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_bastion_host" "Bast" {
  depends_on          = [azurerm_subnet.BastSubnet]
  name                = "bastion_host"
  location            = azurerm_resource_group.Rgs.location
  resource_group_name = azurerm_resource_group.Rgs.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.BastSubnet.id
    public_ip_address_id = azurerm_public_ip.PIP.id
  }
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "Kv" {
  depends_on                  = [azurerm_resource_group.Rgs]
  name                        = "keyvault"
  location                    = azurerm_resource_group.Rgs.location
  resource_group_name         = azurerm_resource_group.Rgs.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Get", "List", "Set", "Recover", "Delete", "Restore", "Purge", "Backup"]

  }
}
resource "azurerm_key_vault_secret" "KVSec" {
  depends_on   = [azurerm_key_vault.Kv]
  for_each     = var.secret
  name         = each.value.secret_name
  value        = each.value.secret_pass
  key_vault_id = azurerm_key_vault.Kv.id
}