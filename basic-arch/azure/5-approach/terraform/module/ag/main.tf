locals {
  frontend_ip_configuration_name = "myAG-FrontendIPConfig"
  products_frontend_port_name             = "myAG-ProductsFrontendPort"
  auth_frontend_port_name             = "myAG-AuthFrontendPort"
  products_backend_http_settings_name     = "myAG-ProductsBackendHTTPSettings"
  auth_backend_http_settings_name         = "myAG-AuthBackendHTTPSettings"
  backend_address_pool_name      = "myAG-BackendAddressPool"
  products_http_listener_name             = "myAG-ProductsHTTPListener"
  auth_http_listener_name             = "myAG-AuthHTTPListener"
  products_probe_name                     = "myAG-products-probe"
  auth_probe_name                         = "myAG-auth-probe"
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
    name = local.products_frontend_port_name
    port = 8080
  }

  frontend_port {
    name = local.auth_frontend_port_name
    port = 8081
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = var.backend_ips
  }

  backend_http_settings {
    name                  = local.products_backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.products_probe_name
    host_name             = var.products_fqdn
  }

  backend_http_settings {
    name                  = local.auth_backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.auth_probe_name
    host_name             = var.auth_fqdn
  }

  http_listener {
    name                           = local.products_http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.products_frontend_port_name
    protocol                       = "Http"
  }

  http_listener {
    name                           = local.auth_http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.auth_frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "myAG-Products-ReqRoutingTable"
    rule_type                  = "Basic"
    http_listener_name         = local.products_http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.products_backend_http_settings_name
  }

  request_routing_rule {
    name                       = "myAG-Auth-ReqRoutingTable"
    rule_type                  = "Basic"
    http_listener_name         = local.auth_http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.auth_backend_http_settings_name
  }

  probe {
    name                                      = local.products_probe_name
    host                                      = var.products_fqdn
    protocol                                  = "Http"
    path                                      = "/api/v1/product/hello"
    interval                                  = 90
    timeout                                   = 90
    unhealthy_threshold                       = 3
  }

  probe {
    name                                      = local.auth_probe_name
    host                                      = var.auth_fqdn
    protocol                                  = "Http"
    path                                      = "/api/v1/auth/hello"
    interval                                  = 90
    timeout                                   = 90
    unhealthy_threshold                       = 3
  }
}