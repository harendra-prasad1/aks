# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = var.location

  tags = {
    env = terraform.workspace
  }
}