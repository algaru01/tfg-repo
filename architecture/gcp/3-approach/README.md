# 3 Acercamiento
Ahora se va a añadir una instancia de base de datos Postgresql proporcionada por el servicio Cloud SQL con una base de datos `student`. En Google, ciertos servicios son desplegados en una VPC propia gestionada por Google y en primera instancia ajena a nuestra propia VPC, y uno de estos servicios es el de Cloud SQL. Por lo tanto, si queremos que la instancia de base de datos tenga únicamente conexión desde las máquinas de VPC necesitaremos configurar un *network peering* o intercambio de tráfico entre ambas VPCs. Para ello, se deberá configurar en nuestra VPC un bloque CIDR reservado que no podremos asignar a ninguna instancia de nuestra red, sino que será utilizado para acceder a los servicios de la VPC de los productores de servicios.

Además, se desplegará un microservicio en el MIG que haga uso de las Base de Datos. Para ello, se ha hecho uso de Packer para crear una imagen con un entorno preparado que será usada en cada instancia del MIG.

## `DB`
Contiene los siguientes recursos:
* `google_sql_database_instance`. Crea la instancia sobre la que correrá la base de datos. Para ello se definen ciertos argumentos como:
	* `database_version`. Donde se define el motor de base de datos usado y su versión.
	* `settings`. Donde se definen ciertas características como el tipo de máquina con `tier`, la configuración IP con `ip_configuration`.
	* `root_password`. Define la contraseña del usuario administrador `postgres`.
	* `deletion_protection`. Establece un bloqueo de seguridad para que la base de datos no pueda ser destruida sin desactivar esta opción previamente.
* `google_sql_database`. Crea la base de datos sobre la instancia construida.
* `google_sql_user`. Crea un usuario con una contraseña dentro de la instancia construida.
* `google_compute_global_address`. Crea el rango de direcciones reservado para la VPC del servicio de la Base de Datos.
* `google_service_networking_connection`. Establece la conexión de nuestra VPC con la del servicio de Base de Datos. En este punto cabe recalcar que al usar el servicio `servicenetworking.googleapis.com`, es posible que tengas que activarlo para tú proyecto.

### Inputs
* `vpc`. VPC donde se usará esta Base de Datos.
* `db_usar`. Usuario de la base de Datos.
* `db_password`. Contraseña del usuario de la Base de Datos

### `Outputs`
* `db_address`. Dirección IP privada de la base de datos.

## Cambios en otros módulos
Ahora el `google_compute_instance_manager` usa la imagen creada con Packer con el entorno preparado y un archivo de inicio que despliega de la aplicación.

## Probar funcionamiento
El código desplegado en la imágen es una antigua versión del products service que en lugar de trabajar con productos trabajaba con estudiantes. De este modo su funcionamiento es igual a dicho microservicio pero haciendo uso de estudiantes en su lugar y sin necesidad de ninguna autenticación.
* POST `/api/v1/student/`. Crea un alumno con un `name`, `email`, `birth`, `age` en la base de datos.
* GET `/api/v1/student/`. Devuelve la lista de alumnos en la base de datos.
* PUT `/api/v1/student/<id_student>` Cambia algún valor de un estudiante a través de sus argumentos.
* DELETE `/api/v1/student/<id_student>`. Elimina un estudiante.

Este servicio añade automáticamente dos estudiantes al inciar, y hace un reinicio de las tablas al acabar.

## Recursos
https://cloud.google.com/vpc/docs/private-services-access?hl=es-419#private-services-supported-services
https://cloud.google.com/sql/docs/postgres/connect-compute-engine?hl=es-419

