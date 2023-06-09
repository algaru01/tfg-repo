resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name = "myLinuxVMScaleSet"

  resource_group_name = var.resource_group_name
  location            = var.location

  instances      = var.number_instances
  sku            = "Standard_B1ls"
  admin_username = "ubuntu"
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
      name                                         = "IPConfiguration"
      subnet_id                                    = var.ss_subnet
      application_gateway_backend_address_pool_ids = [var.ag_backend_address_pool]
      primary                                      = true
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


  /*   upgrade_mode = "Automatic"
  health_probe_id = var.lb_probe
  automatic_instance_repair {
    enabled = true
  } */

  custom_data = base64encode(templatefile("${path.cwd}/../scripts/launch-server.sh", {
    db_address  = var.db_address
    db_user     = var.db_user
    db_password = var.db_password
  }))

}
/* 
resource "azurerm_monitor_autoscale_setting" "this" {
  name = "myVMScaleSetAutoscale"

  resource_group_name = var.resource_group_name
  location = var.location

} */