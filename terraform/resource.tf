provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "testresourcecicd-rg"
  location = "Southeast Asia"

  tags = {
    environment = "Demo"
  }
}
