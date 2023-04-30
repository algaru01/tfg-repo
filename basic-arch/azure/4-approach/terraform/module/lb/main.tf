resource "azurerm_public_ip" "this" {
  name                = "myLb-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "this" {
  name                = "myLb"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_lb_backend_address_pool" "this" {
  name            = "myLb-BackendAddressPool"
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  name            = "myLB-Probe"
  loadbalancer_id = azurerm_lb.this.id
  port            = var.server_port
}

resource "azurerm_lb_rule" "this" {
  name                           = "myLB-Rule"
  loadbalancer_id                = azurerm_lb.this.id
  protocol                       = "Tcp"
  frontend_ip_configuration_name = azurerm_lb.this.frontend_ip_configuration[0].name
  frontend_port                  = var.server_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  backend_port                   = var.server_port
  probe_id                       = azurerm_lb_probe.this.id
}