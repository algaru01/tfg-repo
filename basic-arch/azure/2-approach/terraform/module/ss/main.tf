resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "myLinuxVMScaleSet"

  resource_group_name = var.resource_group_name
  location            = var.location

  sku                 = "Standard_B1ls"
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
      subnet_id                              = var.ss_subnet
      application_gateway_backend_address_pool_ids = [ var.ag_backend_address_pool ]
      primary                                = true
      public_ip_address {
        name = "temporal-ip-address"
      }
    }
  }
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${path.cwd}/../../ssh-keys/ss_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  instances = 2

/*   upgrade_mode = "Automatic"
  health_probe_id = var.lb_probe
  automatic_instance_repair {
    enabled = true
  } */

  admin_username = "ubuntu"
  custom_data    = base64encode(templatefile("${path.cwd}/../scripts/init-script.sh", { server_port = var.server_port }))

/*   depends_on = [
    var.lb_rule
  ] */
}
/* 
resource "azurerm_monitor_autoscale_setting" "this" {
  name = "myVMScaleSetAutoscale"

  resource_group_name = var.resource_group_name
  location = var.location

} */