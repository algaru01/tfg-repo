######################################
#           GET APP IMAGE            #
######################################
data "azurerm_resource_group" "image" {
  name = "myPackerImages"
}

data "azurerm_image" "image" {
  name                = "myPackerImageApplication"
  resource_group_name = data.azurerm_resource_group.image.name
}

######################################
#           SCALE SET                #
######################################
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = "myVMScaleSet"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_B1s"
  instances           = 2
  admin_username      = "ubuntu"

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${path.cwd}/../../ssh-keys/ss_key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.image.id

  network_interface {
    name    = "myNIC"
    primary = true
    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = var.ss_subnet
      application_gateway_backend_address_pool_ids = [var.ag_backend_address_pool_id]
      primary                                = true
    }
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