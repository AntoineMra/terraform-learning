resource "azurerm_resource_group" "admin" {
  name     = "admin-resources-432"
  location = "West Europe"
}

resource "azurerm_virtual_network" "admin" {
  name                = "adminvnet"
  address_space       = ["192.168.1.0/24"]
  location            = azurerm_resource_group.admin.location
  resource_group_name = azurerm_resource_group.admin.name
}

resource "azurerm_subnet" "admin" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.admin.name
  virtual_network_name = azurerm_virtual_network.admin.name
  address_prefixes     = ["192.168.1.224/27"]
}

resource "azurerm_public_ip" "admin" {
  name                = "adminpip"
  location            = azurerm_resource_group.admin.location
  resource_group_name = azurerm_resource_group.admin.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "admin" {
  name                = "adminbastion"
  location            = azurerm_resource_group.admin.location
  resource_group_name = azurerm_resource_group.admin.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.admin.id
    public_ip_address_id = azurerm_public_ip.admin.id
  }
}