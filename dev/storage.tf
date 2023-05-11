resource "azurerm_storage_account" "blob" {
  name                     = "devblobstorage14235"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "devcontainer" {
  name                  = "devcontainer"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}