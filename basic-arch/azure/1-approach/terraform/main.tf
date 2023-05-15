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

module "vm" {
  source = "./module/vm"

  number_instances = 2

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet              = module.vnet.public_subnets[0]

  server_port = 8080
}