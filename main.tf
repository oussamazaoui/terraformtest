provider "azurerm" {
  features {}
  use_cli         = true
  subscription_id = "b75d3631-0815-401c-bad4-9f693f354152"

}
resource "azurerm_resource_group" "rg-vnet" {
  name     = "rg-vnet"
  location = "West Europe"
}

resource "azurerm_network_security_group" "vnet-sg" {
  name                = "vnet-security-group"
  location            = azurerm_resource_group.rg-vnet.location
  resource_group_name = azurerm_resource_group.rg-vnet.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "virtual-network"
  location            = azurerm_resource_group.rg-vnet.location
  resource_group_name = azurerm_resource_group.rg-vnet.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "subnet2"
    address_prefixes = ["10.0.2.0/24"]
    security_group   = azurerm_network_security_group.vnet-sg.id
  }

  tags = {
    environment = "dev"
  }
}
