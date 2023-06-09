resource "azurerm_linux_virtual_machine" "this" {
  count = var.number_instances

  name                = "myLinuxVM-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location

  size = "Standard_B1ls"
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  network_interface_ids = [
    azurerm_network_interface.this[0].id,
  ]
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${path.cwd}/../../ssh-keys/ss_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = "ubuntu"
  custom_data    = base64encode(templatefile("${path.cwd}/../scripts/init-script.sh", { server_port = var.server_port }))
}

resource "azurerm_network_interface" "this" {
  count = var.number_instances != 0 ? 1 : 0

  name                = "myLinuxVM-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

resource "azurerm_public_ip" "this" {
  count = var.number_instances != 0 ? 1 : 0

  name                = "myLinuxVM-PublicIP"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Dynamic"

  lifecycle {
    create_before_destroy = true
  }
}