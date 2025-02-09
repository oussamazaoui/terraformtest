provider "azurerm" {
  features {}
  use_cli         = true
  subscription_id = "b75d3631-0815-401c-bad4-9f693f354152"
  client_id       = var.ClientID
  client_secret   = var.CLIENT_SECRET
  tenant_id       = var.TENANT_ID
}
resource "azurerm_resource_group" "rg-vnet" {
  name     = "rg-vnettest"
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

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg-vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg-vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "subnet2_sg_association" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.vnet-sg.id
}

