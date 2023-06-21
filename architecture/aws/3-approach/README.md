# 3 Acercamiento
En este apartado se incluirá una base de datos situada en una *subnet* privada que no podrá ser accedida por tráfico desde fuera de la VPC. Para ello se hará uso del servicio de RDS de AWS para crear una base de datos Postgresql con una tabla `student`. Además, se desplegará un microservicio dentro del Grupo de Autoescalado que haga uso de esta base de datos.

Para ello se ha desarrollado un nuevo módulo llamado `db`.
## DB
Este módulo consta de los siguientes recursos:
* `aws_db_instance`. Crea la base de datos. Este require obligatoriamente:
	* `identifier`. Identificador de la base de datos.
	* `instance_class`. El tipo de instancia de la base de datos.
	* `allocated_storage`. Indica el tamaño de la base de datos en GB. En este caso será 5 GB.
	* `engine`. El motor que se usará. Por ejemplo: `mysql`, `mariadb` o `posrtgres`, como en este caso.
	* `username`. Nombre del ususario maestro.
	* `password`. Contraseña del usuario maestro.
	Además de dichos argumentos, se han añadido algunos otros, como `port` para indicar el puerto donde escuchará la base de datos o `multi_az` para activar la opción de '*Multi Availability Zone*', que permite que Amazon aprovisione automáticamente y mantenga una o más instancias de base de datos secundarias en espera en una zona de disponibilidad diferente a la principal.
* `aws_db_subnet_group`. A partir de una serie de *subnets*, crea un grupo de *subnets* donde se desplegará la base de datos. En AWS, es obligatorio desplegar las BBDD en varias *subnets* que estén en diferentes regiones.
* `aws_security_group`.  Crea un grupo de seguridad que únicamente permita el tráfico entrante en el puerto que escuchará la base de datos.
### Inputs
* `vpc_id`. ID de la VPC donde se desplegará la base de datos.
* `db_subnets`. Lista de *subnets* donde se desplegará la base de datos.
* `port`. Puerto donde comunicarse con la base de datos.
* `username`. Usuario maestro de la base de datos.
* `password`. Contraseña maestra de la base de datos.
### Outputs
* `address`. Dirección de la base de datos que será usado por el grupo de autoescalado para conectarse a la misma.

## Cambios en otro módulos
* `VPC`.
	* Se ha incluido la creación de *subnets* privadas en el módulo `VPC` con el objetivo de situar ahí la base de datos. Estas tienen el argumento `map_public_ip_on_launch` en `false`.
* `ASG`.
	* Se ha sustituido la imagen anterior por una nueva generada mediante Packer. Esta nueva imágen coniene un entorno preparado para desplegar el código Java creado.
	* Se ha cambiado el `user_data` para que ahora despliegue el código preparado.
	* Se ha añadido la posibilidad de conectarse mediante SSH a sus instancias. Para ello se ha  incluido el recurso `aws_key_pair` para asociar una clave pública a cada instancia, y se ha modificado el grupo de seguridad para permitir también el tráfico por el puerto 22 (SSH).

## Probar funcionamiento
El código desplegado en la imágen es una antigua versión del products service que en lugar de trabajar con productos trabajaba con estudiantes. De este modo su funcionamiento es igual a dicho microservicio pero haciendo uso de estudiantes en su lugar y sin necesidad de ninguna autenticación.
* POST `/api/v1/student/`. Crea un alumno con un `name`, `email`, `birth`, `age` en la base de datos.
* GET `/api/v1/student/`. Devuelve la lista de alumnos en la base de datos.
* PUT `/api/v1/student/<id_student>` Cambia algún valor de un estudiante a través de sus argumentos.
* DELETE `/api/v1/student/<id_student>`. Elimina un estudiante.