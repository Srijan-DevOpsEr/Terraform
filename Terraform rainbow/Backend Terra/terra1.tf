terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.112.0"
    }
  }


  backend "azurerm" {
    resource_group_name  = "backend"                  # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "jaipur"                # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "prity1"                 # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }

}

provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "back1" {
  name     = "backend"
  location = "West Europe"
}
resource "azurerm_storage_account" "backstr" {
  name                     = "jaipur"
  resource_group_name      = azurerm_resource_group.back1.name
  location                 = azurerm_resource_group.back1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}