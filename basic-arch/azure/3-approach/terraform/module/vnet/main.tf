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

resource "azurerm_subnet" "db" {
  count                = var.db_subnet != null ? 1 : 0
  name                 = "db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.db_subnet]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "allow_http_ssh" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  name                = "public-subnets-sg"
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

resource "azurerm_network_security_group" "db" {
  count = var.db_subnet != null ? 1 : 0

  name                = "db-subnet-sg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "Server"
    description                = "Allow traffic to server."
    priority                   = 1002
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = 5432
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = length(var.public_subnets)
  subnet_id                 = element(azurerm_subnet.public[*].id, count.index)
  network_security_group_id = azurerm_network_security_group.allow_http_ssh[0].id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  count                     = var.db_subnet != null ? 1 : 0
  subnet_id                 = azurerm_subnet.db[0].id
  network_security_group_id = azurerm_network_security_group.db[0].id
}
