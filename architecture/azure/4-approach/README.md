# 4 Acercamiento
En este útimo nivel, vamos a aumentar la seguridad de nuestro grupo de escalado cambiando su subnet pública por una privada y permitiendo su conexión SSH únicamente a través de un nodo *jumpbox*. Este nodo, a diferencia del de AWS, no será construido a partir de una máquina virtual, haremos uso del servicio Bastion que ofrece Azure. Para ello se ha incluido un último módulo `bastion`.

## `BASTION`
Ese módulo contiene:
* `azurerm_public_ip`. Crea una IP que será asociada al Bastion.
* `azurerm_bastion_host`. Crea un nodo Bastion
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `bastion_subnet`. ID de la *subnet* donde se desplegará el nodo Bastion.

## Cambios en otros módulos
Se han añadido un *subnets* privadas dentro del módulo `VNET`. Estas únicamente permiten el tráfico SSH entrante desde el nodo Bastion.
También se ha creado una *subnet* específica para el Bastion con el nombre `AzureBastionSubnet` (pues así lo requiere la documentación). De la misma manera, se han asociado varias reglas de seguridad a esta *subred* que eran obligatorias. A modo de resumen, el establcemiento de conexión ssh con el bastion no se hace directamente mediante SSH sino sobre HTTP, usando la API que proporciona Azure.

Además, se ha elimiado el bloque `ip_configuration` de la plantilla del SS para eliminar su dirección IP
pública.

## Referencias
https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg