resource "azurerm_public_ip" "this" {
  name                = "bastion-publicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "tfgbastion-ssh"
}

resource "azurerm_bastion_host" "this" {
  name                = "bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "Standard"
  tunneling_enabled = true    //Quitar?

  ip_configuration {
    name                 = "bastionIPConfig"
    subnet_id            = var.bastion_subnet
    public_ip_address_id = azurerm_public_ip.this.id
  }
}