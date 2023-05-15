# 2 Acercamiento
En este nuevo nivel mejoraremos la seguridad y la disponibilidad de nuestro servicio con el uso de un set de escalado y un balanceador de carga. Se ha desarrollado un módulo para cada uno de ellos.

## LB
Crea un Application Gateway para distribuir el tráfico HTTP. Consta de un único recurso llamado `azurerm_application_gateway` que contiene los siguientes argumentos:
* `sku`. Determina el nombre, *tier* y capacidad SKU del Application Gateway. Puede tener distintos valores como `Standard` o `Standard_v2` dependiendo de a versión de AG que se requiera.
* `gateway_ip_configuration`. Configura la *subnet* a la que estará asociado dicho Application Gateway.
* `frontend_port`. Configura el puerto en el que escuchará este servicio.
* `frontend_ip_configuration`. Configura las direciones públicas y privadas que usará.
* `backend_address_pool`. Define el conjunto de *backends* a los que distribuirá el tráfico. Su `id` será asociado luego a la interfaz de red de cada instancia que servirá como *backend*.
* `backend_http_settings`. Crea el conjunto de configuraciones HTTP que serán usados para enrutar el tráfico.
* `http_listener`. Crea el conjunto de *listeners* que escucharán en un puerto y dirección asignados mediante el `frontend_port` y el `frontend_ip_configuration`.
* `request_routing_rule`. Crea el cnojunto de reglas que enlazan un `http_listener` con un grupo `backend_address_pool` y su `backend_http_settings`.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `server_port`. Puerto donde abrir el servidor web.
* `ag_subnet`. *Subnet* donde se desplegará el Aplication Gateway.
### Outputs
* `ag_public_ip`. IP pública del Application Gateway.
* `ag_backend_address_pool`. ID del `backend_address_pool` que será *linkeado* al *Scale Set*.

## SS
Contiene los siguientes recursos:
* `azurerm_linux_virtual_machine_scale_set`. Crea un Set de Escalado de máquinas virtuales de Linux de la misma manera que lo hacia el `azurerm_linux_virtual_machine` con la excepción de que ahora existe un argumento `instance` para indicar el número de instancias que tendrá este Set de Escalado. Además se ha establecido la reparación automatica de instancias usando el `lb_probe` del Load Balancer y estableciendo el `upgrade_mode` en `Automatic`.
* A modo de mejora, es posible añadir otro recurso que monitorice este recurso para escalarlo mejor.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `ss_subnet`. ID de la *subnet* donde se desplegará el SS.
* `server_port`. Puerto donde abrir el servidor web.
* `ag_backend_address_pool`.  ID del `backend_address_pool` del Application Gateway.