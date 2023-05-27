# 6 Acercamiento
En este nuevo acercamiento se sustituirán las máquinas virtuales por contenedores del servicio AWS Fargate. Este ervicio Cloud te permite correr contenedores sin tener que gestionar máquinas EC2 de Amazon, lo que te permite centrarte simplemente en el entorno que correrá tu aplicación. Para ello se han desarrollado dos nuevos módulos que sustituirán al antiguo `ASG`.

Además se ha desarrollado un nuevo microservicio de modo que este nuevo nivel incluya también la comunicación servidor-servidor.

En apartados anteriores, para desplegar nuestro codigo en cada máquina virtual haciamos uso de Packer para crear imágenes sobre la que se construiria cada EC2. En este caso, se hace uso de Docker.
Para ello, se ha creado un Dockerfile que permite definir en sus variables de entorno ciertos rasgos del código, para poder modificarlo cuando queramos; y lanza nuestro código a partir de la imagen openjdk:17-oracle.
Para subir la imagen al contenedor privado de ECR(importante, este contenedor debe de haber sido creado previamente), primero creamos la imagen ejecutando dicho Dockerfile con:
docker build -t <image_name> <dockerfile_path>

Luego deberemos hacer login en el ECR con:
docker login --username AWS --password <ecr_password> <ecr_url>
Es posible obtener la <ecr_password> con: aws ecr get-login-password --region <ecr_region>

Seguidamente etiquetamos la imagen con:
docker tag <image_name> <ecr_repository>:<tag>
donde tag puede ser latest por ejemplo.

Y por último _pusheamos_ la imágen al repository privado de ECR:
docker push <ecr_url>:<tag>


## `ECR`
Este módulo crea un Elastic Container Registry privado que contendrá la imágen preparada con nuestro código. Y simplemente contiene:
* `aws_ecr_repository`. Crea el repositorio ECR.
* `aws_ecr_lifecycle_policy`. Crea una politica para nuestro repositorio ECR. En este caso de mantener la imagen desplegada con el tag _latest_ y mantener únicamente las últimas 2 imágenes.

### Outputs
* `ecr_repository_url`. URL del ECR creado.

## `ECS`
Este módulo contiiene los recursos necesarios para desplgear un contenedor en AWS Fargate.
* `aws_ecs_cluster`. Crea el clúster donde se desplegarán las tareas.
* `aws_iam_policy_document`, `aws_iam_role` y `aws_iam_role_policy_attachment`. Asignan los permisos necesarios a las tareas de ejecución.
* `aws_ecs_task_definition`. Crea la definición de la tarea a partir de un archivo JSON que, entre otras cosas, define la imágen, configura un log, configura el mapeo de puertos, las variables de entorno y la cpu y memoria usados.
* `aws_ecs_service`. Crea el servicio que se desplegará en el `aws_ecs_cluster` y que creará tareas definidas en el `aws_ecs_task_definition`. Allí se configura la interfaz de red, con la *subnet* donde se desplegara, y el balanceador de carga que le distribuirá el tráfico.
* `aws_cloudwatch_log_group`. Que mantendrá un log del estado del servicio.

### Inputs
* `VPC`. ID del VPC donde se desplegarán los recursos.
* `subnets`. Subnets donde se desplegarán los servicios.
* `region`. Región donde se desplegarán los recursos.
* `lb_X_target_group_arn`. ARN del Load Balancer que distribuirá el tráfico al servicio X.
* `lb_sg`. Grupo de seguirdad del Load Balancer de donde únicamente aceptará tráfico TCP estas instancias.
* `repository_url`. URL del repositorio donde se almacena la imagen que se desplegará.
* `db_address`. Dirección de la base de datos.
* `db_user`. Usuario de la base de datos.
* `db_password`. Contraseña del usuario de la base de datos.
* `db_port`. Puerto de la base de datos.
* `auth_url`. URL del servicio de autenticación.
* `X_server_port`. Puerto donde se despliega el servicio X.

## Cambios en otros módulos.
Ahora el Balanceador de Carga tiene 2 `aws_lb_listener_rule` y 2 `aws_lb_target_group`, uno para cada microservicio.
En el módlo `VPC`se ha añadido un `aws_nat_gateway` que será usado por los dos microservicios para acceder al ECR y descargarse la imágen. Este NAT Gateway se lanza en una subnet pública y permite enviar tráfico hacia Internet pero no recibir, por lo que es perfecta para subredes privadas que requieren de ciertas conexiones afuera de la VPC, como en este caso. Para ello, la subred privada ahora tiene una tabla de rutas nueva que envia estas conexiones afuera de la VPC a través de la NAT.