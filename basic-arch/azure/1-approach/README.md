# 1 Acercamiento
En este primer acercamiento se quiere crear una única máquina virtual en Azure que despliegue un pequeño servidor web en el puerto 8080. Para ello se crerá una VNet y una *subnet* pública donde se desplegará dicha VM. 

En Azure todos los recursos pertenecen a un grupo de recursos, que en Terraform se construye con `azurerm_resource_group`. En esste caso establecerá la localización de los mismos en `West Europe`. Así, dentro de este grupo se han desplegado 2 módulos: `VM` y `VNET`.

## `VNET`
Contiene los siguientes recursos:
* `azurerm_virtual_network`. Crea una VNet dado un espacio de direcciones..
* `azurerm_subnet`. Crea una *subnet* dentro de una VNet dado un espacio de direcciones. En Azure no hay distinción entre subredes privada o públicas. Para gestionar esta característica es necesario crear un grupo de seguridad que limite el tráfico en cada una de estas subnets.
* `azurerm_network_security_group`.  Crea un grupo de seguridad. En este caso, como queremos un servidor web accesible desde el exterior, permitimos el de SSH y al puerto del servidor.
* `azurerm_subnet_network_security_group_association`. Establece una asociación entre un `azurerm_subnet` y un `azurerm_network_security_group`.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `cidr_block`. Bloque de direcciones para la VNet.
* `public_subnets`. Lista de bloques para cada *subnet* pública.
### Outputs
* `public_subnets`. Lista de IDs de cada *subnet* pública creada.

## VM
Contiene los siguientes recursos:
* `azurerm_linux_virtual_machine`. Crea una máquina virtual Linux. Este recibe de argumentos:
	* `size`. Tipo de máquina a crear.
	* `os_disk`. Indica características del disco para el sistema operativo.
	* `admin_username`. Nombre de usuario del administrador.
	* `source_image_reference`. Imágen a usar. En este caso Ubuntu 18.04
	* `custom_data`. *Script* a ejecutar cuando inicie la VM.
* `azurerm_network_interface`. Interfaz de red que será asociada a un `azurerm_linux_virtual_machine`. Dentro de su argumento `ip_configuration` es posible configurar características de red como una IP pública.
* `azurerm_public_ip`. IP pública que, en este caso, será asociada a un `azurerm_network_interface`.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `subnet`. ID de la *subnet* donde se desplegará la VM.
* `server_port`. Puerto donde abrir el servidor web.
* `number_instances`. Número de VM a crear.
### Outputs
* `vms_public_ip`. IP pública de cada VM creada.