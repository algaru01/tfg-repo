source "azure-arm" "autogenerated_1" {
    //use_interactive_auth = true
  async_resourcegroup_delete = true
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  
  client_id                         = # Your client ID
  client_secret                     = # Your client secret
  subscription_id                   = # Your subsrciption ID
  tenant_id                         = # Your tenant ID

  managed_image_name                = "myPackerImage2"
  managed_image_resource_group_name = "myPackerImages"

  os_type                           = "Linux"
  image_publisher                   = "Canonical"
  image_offer                       = "UbuntuServer"
  image_sku                         = "18.04-LTS"

  location                          = "West Europe"
  vm_size                           = "Standard_B1ls"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "shell" {
    script = "./init-script.sh" #Actualiza el sistema e instala openjdk-17
  }

  provisioner "file" {
    source      = "./demo-1.0.0-SNAPSHOT.jar"
    destination = "/home/ubuntu/src/demo-1.0.0-SNAPSHOT.jar"
  }
}