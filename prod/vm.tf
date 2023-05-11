variable "vm_count" {}

locals {
  vm_names = ["vm-we", "vm-us"]
  rg_names = ["rg-prod-we", "rg-prod-eu"]
  locations = ["West Europe", "East US"]
}

resource "azurerm_resource_group" "rg-prod" {
  count = 2
  name  = local.rg_names[count.index]
  location = local.locations[count.index]
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "prod" {
  count = 2
  name                = "network-${local.vm_names[count.index]}"
  resource_group_name = azurerm_resource_group.rg-prod[count.index].name
  location            = azurerm_resource_group.rg-prod[count.index].location
  address_space       = ["10.${count.index + 1}.0.0/16"]
}

resource "azurerm_subnet" "prod" {
  count = 2
  name                 = "subnet-${local.vm_names[count.index]}"
  resource_group_name  = azurerm_resource_group.rg-prod[count.index].name
  virtual_network_name = azurerm_virtual_network.prod[count.index].name
  address_prefixes     = ["10.0.${count.index + 1}.0/24"]
}

resource "azurerm_network_interface" "prod" {
  count = 2
  name                = "prod-nic-${local.vm_names[count.index]}"
  location            = azurerm_resource_group.rg-prod[count.index].location
  resource_group_name = azurerm_resource_group.rg-prod[count.index].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prod[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = 2
  name                = local.vm_names[count.index]
  resource_group_name = azurerm_resource_group.rg-prod[count.index].name
  location            = azurerm_resource_group.rg-prod[count.index].location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.prod[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}