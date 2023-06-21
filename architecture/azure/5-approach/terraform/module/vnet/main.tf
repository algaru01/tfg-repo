######################################
#                VNET                #
######################################
resource "azurerm_virtual_network" "this" {
  name                = "myVirtualNetwork"
  resource_group_name = var.resource_group_name
  location            = var.location

  address_space = [var.cidr_block]
}

######################################
#               SUBNETS              #
######################################
resource "azurerm_subnet" "public" {
  count                = var.public_subnets != null ? length(var.public_subnets) : 0
  name                 = "public-subnets-${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.public_subnets[count.index]]
}

resource "azurerm_subnet" "private" {
  count                = var.private_subnets != null ? length(var.private_subnets) : 0
  name                 = "private-subnets-${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.private_subnets[count.index]]
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

resource "azurerm_subnet" "bastion" {
  count = var.bastion_subnet != null ? 1 : 0
  name  = "AzureBastionSubnet"

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.bastion_subnet]
}

######################################
#           SECURITY GROUPS          #
######################################
resource "azurerm_network_security_group" "public" {
  name                = "public-subnets-sg"
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
    destination_port_range     = "*" //var.server_port
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    description                = "Allow traffic http."
    priority                   = 1003
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = 80
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    description                = "Allow traffic https."
    priority                   = 1004
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = 443
    destination_address_prefix = "*"
  }

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
}

resource "azurerm_network_security_group" "private" {
  name                = "private-subnets-sg"
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
    source_address_prefix      = var.bastion_subnet
    destination_port_range     = 22
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "bastion" {
  count = var.bastion_subnet != null ? 1 : 0

  name                = "bastion-subnet-sg"
  resource_group_name = var.resource_group_name
  location            = var.location

  # Inbound
  security_rule {
    name                       = "AllowHttpsInbound"
    description                = "Ingress Traffic from public internet."
    priority                   = 1001
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "Internet"
    destination_port_range     = 443
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowGatewayManagerInbound"
    description                = "Ingress Traffic from Azure Bastion control plane."
    priority                   = 1002
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "GatewayManager"
    destination_port_range     = 443
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAzureLoadBalancerInbound"
    description                = "Ingress Traffic from Azure Load Balancer."
    priority                   = 1003
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = 443
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowBastionHostCommunication"
    description                = "Ingress Traffic from Azure Bastion data plane."
    priority                   = 1004
    access                     = "Allow"
    protocol                   = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_ranges    = [8080, 5701]
    destination_address_prefix = "VirtualNetwork"
  }

  # Outbound
  security_rule {
    name                       = "AllowSshRdpOutbound"
    description                = "Allow SSH and RDP  traffic to VMs."
    priority                   = 1001
    access                     = "Allow"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_ranges    = [22, 3389]
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAzureCloudOutbound"
    description                = "Egress Traffic to other public endpoints in Azure."
    priority                   = 1002
    access                     = "Allow"
    protocol                   = "Tcp"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = 443
    destination_address_prefix = "AzureCloud"
  }

  security_rule {
    name                       = "AllowBastionCommunication"
    description                = "Egress Traffic to Azure Bastion data plane."
    priority                   = 1003
    access                     = "Allow"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_ranges    = [8080, 5701]
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowHttpOutbound"
    description                = "Allow traffic to Internet."
    priority                   = 1004
    access                     = "Allow"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = 80
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_network_security_group" "db" {
  count = var.db_subnet != null ? 1 : 0

  name                = "db-subnet-sg"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "db"
    description                = "Allow traffic to db."
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

######################################
#     SECURITY GROUP ASSOCIATIONS    #
######################################
resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = var.public_subnets != null ? length(var.public_subnets) : 0
  subnet_id                 = element(azurerm_subnet.public[*].id, count.index)
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = var.private_subnets != null ? length(var.private_subnets) : 0
  subnet_id                 = element(azurerm_subnet.private[*].id, count.index)
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  count                     = var.db_subnet != null ? 1 : 0
  subnet_id                 = azurerm_subnet.db[0].id
  network_security_group_id = azurerm_network_security_group.db[0].id
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  count                     = var.bastion_subnet != null ? 1 : 0
  subnet_id                 = azurerm_subnet.bastion[0].id
  network_security_group_id = azurerm_network_security_group.bastion[0].id
}
