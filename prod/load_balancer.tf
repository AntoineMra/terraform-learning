resource "azurerm_public_ip" "lb" {
  name                = "publicIPForLB"
  location            = azurerm_resource_group.rg-prod[0].location
  resource_group_name = azurerm_resource_group.rg-prod[0].name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "loadBalancer"
  location            = azurerm_resource_group.rg-prod[0].location
  resource_group_name = azurerm_resource_group.rg-prod[0].name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backendPool"
}

resource "azurerm_lb_probe" "lb" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "healthProbe"
  protocol            = "Http"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
  request_path        = "/"
}

resource "azurerm_lb_rule" "lb" {
  name                           = "prod-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids        = [ azurerm_lb_backend_address_pool.lb.id ] 
  probe_id                       = azurerm_lb_probe.lb.id
  loadbalancer_id                = azurerm_lb.lb.id
}
