# 2 Acercamiento
En este nuevo nivel mejoraremos la seguridad y la disponibilidad de nuestro servicio con el uso de un set de escalado y un balanceador de carga. Se ha desarrollado un módulo para cada uno de ellos.

## LB
Contiene los siguientes recursos:
* `azurerm_public_ip`. IP pública que será asociada a un balanceador de carga.
* `azurerm_lb`. Crea la base del balanceador de carga. La parte principal de este recurso es el `frontend_ip_configuration`, pues configura el *Frontend* de nuestro Balanceador de Carga.
* `azurerm_lb_backend_address_pool`. Crea un *Backend Pool*, que contiene los grupos de recursos que recibirán el tráfico del Balanceador de Carga, en este caso el Set de Escalado.
* `azurerm_lb_probe`. Crea un *Health Probe*, que se utiliza para verificar el estado de los recursos del *Backend Pool*. En este caso comprobará el puerto donde corre nuestro servidor.
* `azurerm_lb_rule`. Crea una regla para el Balanceador de Carga que indica como distribuir el tráfico entre los recursos del *Backend Pool*. En este caso reenviará todo el tráfico entrante al puerto del servidor al mismo puerto de una instancia del grupo de escalado.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `server_port`. Puerto donde abrir el servidor web.
### Outputs
* `backend_address_pool_id`. ID del `azurerm_lb_backend_address_pool` creado y que será usado por el Set de Escalado.
* `lb_public_ip`. IP pública del Balanceador de Carga.
* `lb_rule`. ID del `azurerm_lb_rule` creado.
## SS
Contiene los siguientes recursos:
* `azurerm_linux_virtual_machine_scale_set`. Crea un Set de Escalado de máquinas virtuales de linux de la misma manera que lo hacia el `azurerm_linux_virtual_machine` con la excepción de que ahora existe un argumento `instance` para indicar el número de instancias que tendrá este Set de Escalado.
* A modo de mejora, es posible añadir otro recurso que monitorice este recurso para escalarlo mejor.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `ss_subnet`. ID de la *subnet* donde se desplegará el SS.
* `server_port`. Puerto donde abrir el servidor web.
* `lb_backend_address_pool_id`.  ID del `azurerm_lb_backend_address_pool` del LB.
* `lb_rule`. ID del `azurerm_lb_rule` del LB.