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
  db_subnet      = "10.0.200.0/28" 
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

  db_address  = "my-db-flexible-server.postgres.database.azure.com" #module.db.db_address
  db_password = "usuario" #var.db_password
  db_user     = "password" #var.db_user

  depends_on = [
    module.db
  ]

}

module "db" {
  source = "./module/db"

  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  vnet_id = module.vnet.vnet_id
  database_subnet = module.vnet.db_subnet_id

  db_user     = var.db_user 
  db_password = var.db_password
}