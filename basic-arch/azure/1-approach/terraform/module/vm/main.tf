resource "azurerm_linux_virtual_machine" "this" {
  name                = "myVM"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${path.cwd}/test_asg.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.cwd}/../scripts/init-script.sh", { server_port = var.server_port }))
}

resource "azurerm_public_ip" "this" {
  name                = "myPublicIp"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_network_interface" "this" {
  name                = "myNIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this.id
  }
}