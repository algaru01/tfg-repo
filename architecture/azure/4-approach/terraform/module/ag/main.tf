locals {
  frontend_ip_configuration_name = "myAG-FrontendIPConfig"
  frontend_port_name             = "myAG-FrontendPort"
  backend_http_settings_name     = "myAG-BackendHTTPSettings"
  backend_address_pool_name      = "myAG-BackendAddressPool"
  http_listener_name             = "myAG-HTTPListener"
  probe_name                     = "myAG-products-probe"
}

resource "azurerm_public_ip" "this" {
  name                = "myAG-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "this" {
  name                = "myApplicationGateway"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "myAG-IPConfig"
    subnet_id = var.ag_subnet
  }

  frontend_port {
    name = local.frontend_port_name
    port = 8080
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "myAG-ReqRoutingTable"
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
  }

  probe {
    name                = local.probe_name
    host                = "127.0.0.1"
    protocol            = "Http"
    path                = "/api/v1/student/hello"
    interval            = 90
    timeout             = 90
    unhealthy_threshold = 3
  }
}