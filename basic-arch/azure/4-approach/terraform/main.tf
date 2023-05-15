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

  cidr_block      = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24"]
  public_subnets = [ "10.0.2.0/24" ]
  bastion_subnet  = "10.0.200.0/27"
  db_subnet       = "10.0.201.0/28"
}

module "ag" {
  source = "./module/ag"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ag_subnet = module.vnet.public_subnets[0]

  server_port = var.server_port
}

module "ss" {
  source = "./module/ss"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ss_subnet = module.vnet.private_subnets[0]

  ag_backend_address_pool_id = module.ag.ag_backend_address_pool.id

  db_address  = module.db.db_address
  db_password = var.db_password
  db_user     = var.db_user

  depends_on = [
    module.db
  ]
}

module "db" {
  source = "./module/db"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  vnet_id         = module.vnet.vnet_id
  database_subnet = module.vnet.database_subnet

  db_user     = var.db_user
  db_password = var.db_password
}

module "bastion" {
  source = "./module/bastion"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  bastion_subnet = module.vnet.bastion_subnet
}