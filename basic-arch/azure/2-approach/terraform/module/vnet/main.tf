resource "azurerm_virtual_network" "this" {
  name                = "myVirtualNetwork"
  resource_group_name = var.resource_group_name
  address_space       = [var.cidr_block]
  location            = var.location
}

resource "azurerm_subnet" "public" {
  count                = length(var.public_subnets)
  name                 = "public-subnets-${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.public_subnets[count.index]]
}

resource "azurerm_network_security_group" "this" {
  name                = "mySecurityGroup"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "SSH"
    description                = "Allow SSH traffic."
    priority                   = 1001
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = 22
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Server"
    description                = "Allow traffic to server."
    priority                   = 1002
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = var.server_port
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = length(var.public_subnets)
  subnet_id                 = element(azurerm_subnet.public[*].id, count.index)
  network_security_group_id = azurerm_network_security_group.this.id
}
