resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "myVMScaleSet"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_B1ls"
  instances           = 2
  admin_username      = "ubuntu"

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${path.cwd}/../../ss_key.pub")
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

  network_interface {
    name    = "myNIC"
    primary = true
    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_address_pool_id]
      primary                                = true
      public_ip_address {
        name = "temporal-ip-address"
      }
    }
  }

  custom_data = base64encode(templatefile("${path.cwd}/../scripts/init-script.sh", { server_port = var.server_port }))

  depends_on = [
    var.lb_rule
  ]
}