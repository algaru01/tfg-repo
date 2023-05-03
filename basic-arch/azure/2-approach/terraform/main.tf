terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.51.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "myResourceGroup"
  location = "West Europe"
}

module "vnet" {
  source = "./module/vnet"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  cidr_block     = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24"]
}

module "lb" {
  source = "./module/lb"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  server_port = var.server_port
}

module "ss" {
  source = "./module/ss"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ss_subnet = module.vnet.public_subnets[0]

  lb_backend_address_pool_id = module.lb.backend_address_pool_id
  lb_rule                    = module.lb.lb_rule

  server_port = var.server_port
}