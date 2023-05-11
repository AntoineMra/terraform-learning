resource "azurerm_mysql_server" "dev" {
  name                = "devmysql1234"
  resource_group_name = azurerm_resource_group.dev.name
  location            = azurerm_resource_group.dev.location
  version             = "5.7"
  administrator_login = "adminuser"
  administrator_login_password = "password1234!"
  sku_name            = "B_Gen5_1"
  ssl_enforcement_enabled = true
}

resource "azurerm_mysql_database" "devdb" {
  name                = "dev-db"
  resource_group_name = azurerm_resource_group.dev.name
  server_name         = azurerm_mysql_server.dev.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "devfw" {
  name                = "allow-all-ips"
  resource_group_name = azurerm_resource_group.dev.name
  server_name         = azurerm_mysql_server.dev.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
