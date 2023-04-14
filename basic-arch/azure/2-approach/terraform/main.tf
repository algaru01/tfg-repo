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
  name     = "myResourceGroup2"
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
  location = azurerm_resource_group.this.location
  subnet_id = module.vnet.subnets_id[0]

  server_port = 8080
}

module "ss" {
  source = "./module/ss"

  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  subnet_id = module.vnet.subnets_id[0]
  lb_backend_address_pool_id = module.lb.backend_address_pool_id
  lb_rule = module.lb.lb_rule

  server_port = 8080
}