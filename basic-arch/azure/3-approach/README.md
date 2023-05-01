# 3 Acercamiento

En este apartado se incluirá una base de datos situada en una *subnet* privada que no podrá ser accedida por tráfico desde fuera de la VPC. Para ello se hará uso del servicio de Azure Database de Azure para crear una base de datos Postgresql con una tabla `student`. Además, se desplegará un microservicio dentro del Grupo de Autoescalado que haga uso de esta base de datos.

Para ello se ha desarrollado un nuevo módulo `DB`.
## `DB`
Contiene los siguientes recursos:
* `azurerm_postgresql_flexible_server`. Crea un servidor flexible para una base de datos Postgresql. Recibe los siguientes argumentos:
	* `version`. Versión de la base de datos. En este caso se usa PostgreSQL 13.
	* `administrator_login`. Nombre de usuario maestro.
	* `administrator_password`. Contraseña del usuario maestro.
	* `zone`. Zona de disponibilidad donde se desplegará dicha base de datos.
	* `storage_mb`. Tamaño en MB de la base de datos.
	* `sku_name`. Nombre de SKU.
* `azurerm_postgresql_flexible_server_database`. Crea la base de datos dentro del servidor `azurerm_postgresql_flexible_server`.
* `azurerm_private_dns_zone`. Crea una nombre de dominio privado para el servidor de la base de datos.
* `azurerm_private_dns_zone_virtual_network_link`. Establece una asociación entre una VNet y un servidor de base de datos.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se crearán los recursos.
* `location`. Localización donde se van a desplegar cada recurso.
* `vnet_id`. ID de la VNet donde se desplegará la base de datos.
* `database_subnet`. ID de la *subnet* donde se desplegará la base de datos.
* `db_user`. Usuario maestro de la base de datos.
* `db_password`. Contraseña maestra de la base de datos.

## Cambios en otros módulos
* El módulo `VNET` ahora también crea una *subnet* exclusivamente para la base de datos. Esta requiere obligatoriamente de ciertos permisos específicos que se indican en la documentación. También se ha añadido un grupo de seguridad específico para dicha *subnet* que solo acepta conexiones en el puerto en el que funciona la base de datos.
* En el módulo `SS`:
	* Se ha sustituido la imagen anterior por una nueva generada mediante Packer. Esta nueva imágen coniene un entorno preparado para desplegar el código Java creado.
	* Se ha cambiado el `user_data` para que ahora despliegue el código preparado.