terraform {
  backend "azurerm" {
    resource_group_name  = "poc001"
    storage_account_name = "stgactdewas"
    container_name       = "tfstate-dev"
    key                  = "terraform.tfstate"
  }
}