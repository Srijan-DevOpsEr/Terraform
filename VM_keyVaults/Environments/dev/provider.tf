
terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.1"

    }
  }
}

provider "azurerm" {
  features {
    # key_vault {
    #   purge_soft_delete_on_destroy    = true
    #   recover_soft_deleted_key_vaults = true
    # }
  }
  subscription_id = "80c09414-fdbe-450b-a034-cfac22b87b45"
}

