# 4 Acercamiento

Ahora se va a añadir una instancia de base de datos Postgresql proporcionada por el servicio Cloud SQL. Para ello, se hace uso del recurso 'google_sql_database_instance' que gestiona el tipo de base de datos y su versión (en este caso Postgres 13), el tipo de máquina y configura la conexión red. En este caso se requiere que esta base de datos únicamente sea accedida desde las instancias de máquinas virtuales lanzandas, por lo tanto habrá que configurarla para que únicamente tenga una IP privada.

En Google, ciertos servicios son desplegados en una VPC propia gestionada por Google y en primera instancia ajena a nuestra propia VPC, y uno de estos servicios es el de Cloud SQL. Por lo tanto, si queremos que la instancia de base de datos tenga únicamente conexión desde las máquinas de VPC necesitaremos configurar un network peering o intercambio de tráfico entre ambas VPCs.
Para ello, primeramente se configurará en nuestra VPC un bloque CIDR reservado que no podremos asignar a ninguna instancia de nuestra red, sino que será utilizado para acceder a los servicios de la VPC de los productores de servicios. Este se hace con el recurso 'google_compute_global_address' en modo VPC_PEERING.
Y finalmente se crea la conexión privada con 'google_service_networking_connection' que hace uso de la API "servicenetworking.googleapis.com", por lo que es posible que haya que activar esta para tú proyecto.

Una vez creada la instancia de la base de datos y la conexión a esta, será posible crear las bases de datos que se quieran con 'google_sql_database' y los usuarios con 'google_sql_user'


Además, se ha creado una imagen con Packer con un entorno preparado para desplegar una aplicación que haga uso de la base de datos (por defecto tendrá 2 estudiatnes) con los siguientes endpoints:
    * GET /api/v1/student/ devolverá la lista de estudiantes en la base de datos.
    * POST /api/v1/student/ permitirá añadir un estudiante a la base de datos.
    * DELETE /api/v1/student/{studentID} borrará el estudiante con dicho ID.
    * PUT /api/v1/student/{studentID} permitirá modificar datos de dicho estudiante.
    * GET /api/v1/student/hello devolverá un hola mundo.

## Recursos
https://cloud.google.com/vpc/docs/private-services-access?hl=es-419#private-services-supported-services
https://cloud.google.com/sql/docs/postgres/connect-compute-engine?hl=es-419

