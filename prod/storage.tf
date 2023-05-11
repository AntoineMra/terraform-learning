resource "azurerm_storage_account" "blob" {
  name                     = "prodblobstorage14235"
  resource_group_name      = azurerm_resource_group.rg-prod[0].name
  location                 = azurerm_resource_group.rg-prod[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "prod"
  }
}

resource "azurerm_storage_container" "prodcontainer" {
  name                  = "prodcontainer"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}