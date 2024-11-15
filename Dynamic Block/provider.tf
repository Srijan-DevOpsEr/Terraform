terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }
  }
}

provider "azurerm" {
  features {

  }
  subscription_id = "36a7daa3-9fd1-4077-8dfd-f83ca8c6cc4e"
}
