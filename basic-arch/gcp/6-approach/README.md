# 6 Acercamiento
Hasta ahora, nuestro microservicio corria en una máquina virtual con una imágen precreada con Packer. Esto suponia tener que gestionar dicha VM y tener que crear imágenes nuevas cada vez que lanzemos una nueva versión del servicio. En este último nivel, dicho paradigma será sustituido por un servicio de contenedores sin servidor llamado Cloud Run. Además, se ha desarrollado un nuevo microservicio de autenticación que establecerá comunicaciones con el otro micro.
Por lo tanto se desarrollaran 2 módulos, uno creará un Artifact Registry para guardar imágenes Docker con cada versión de nuestros microservicios y otro lanzará los contenedores que harán uso de dichas imágenes.
Para subir una imagen a un artifact repository:
1. docker tag <docker_image>:<tag> <ar_url>/<image_name>:<tag>. Por ejemplo docker tag java-docker:latest europe-southwest1-docker.pkg.dev/basic-arch-384210/my-repository/java-app:latest
2. docker push <ar_url>/<image_name>:<tag>. Por ejemplo, docker push europe-southwest1-docker.pkg.dev/basic-arch-384210/my-repository/java-app:latest

## `AR`
Este módulo crea únicamente un Artifact Registry donde guardar las imágenes precreadas. Consta únicamente de un recurso:
* `google_artifact_registry_repository`. Crea el Artifact Registry con un formato de paquetes establecido en `format`, en este caso Docker.

### Inputs


### Outputs
* `name`. Nombre del repositorio.

## `CR`
Este módulo creará el servicio de Cloud Run que lanzará los contenedores que ejecutarán cada microservicio. Consta de los siguientes recursos:
* `google_cloud_run_v2_service`. Crea el servicio de Cloud Run. En este caso, se crea una plantilla con un contenedor donde se especifica la imágen y varias variables de entorno; se especifica el puerto a exponer y se establece que la CPU esté siempre activa (en contraposición a iniciarse cada vez que recibe una solicitud). Además se establece el `ingress` como `INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER`, lo que permitirá únicamente el tráfico interno y mediante un balanceador de carga. Por último, el bloque `vpc_access` permite a los entornos sin servidores, como Cloud Run, conectarse a recursos dentro de tu VPC a través de un elemento llamado _conector_. Este asignará una serie de direcciones IP privadas a dichos servicios sin servidor, de modo que cuando quieran interactuar con algún elemento de la VPC (como la base de datos), usarán estas IP privadas.
* `google_secret_manager_secret`. Configura un valor _secreto_ que será usado por un contenedor, en este caso la contraseña de la base de datos, para aumentar su seguridad.
* `google_secret_manager_secret_version`. Configura una versión de un `google_secret_manager_secret`.
* `google_secret_manager_secret_iam_member`. Configura los permisos necesarios para acceder al `google_secret_manager_secret`.
* `google_cloud_run_v2_service_iam_binding`. Configura los permisos necesarios para lanzar un contenedor.
* `google_compute_region_network_endpoint_group`. Configura un grupo de extremos de red (NEG) que especifica un grupo de backend para un balanceador de carga. En este caso será nuestro servicio de Cloud Run.

### Inputs
* `location`. Región donde se lanzará el servicio de Cloud Run.
* `project_id`. ID del proyecto usado para no hardcodear la URL del repositorio.
* `X_port`. Puerto que expondrá el micro X.
* `ar_name`. Nombre del repositoro donde se encuentra la imagen Docker que usará el contenedor.
* `db_address`. Dirección de la base de datos.
* `db_port`. Puerto de la base de datos.
* `db_user`. Usuario de la base de datos.
* `db_password`. Contraseña de la base de datos.
* `connector`. Conector usado para acceder a los servicios de la VPC.
### Outputs
* `X_network_endpoint_group_id`. NEG del micro X usado como _backend_ en el Load Balancer.

## Cambios en otros módulos
Ahora el Load Balancer usa como grupo del NEG creado en el módulo `CR`. Esto supone que ciertos servicios como el `google_compute_region_health_check` dejen de estar disponibles. También se ha modificado el 
`google_compute_region_url_map` para distribuir el tráfico a cada micro en función de la URL.

Por otro lado, ahora el módulo `VPC` crea un conector a través de `google_vpc_access_connector` además de una subred con máscara de red `/28` que usará este. Esta subred tiene activado el `private_ip_google_access`. Esto es importante porque de forma predeterminada, únicamente los recursos de tu VPC que tienene IP pública(o en su defecto que usan Cloud NAT) pueden acceder directamente a Internet y a los servicios de Google Cloud como Pub/Sub y Cloud Run(recuerda que estos servicios no se lanzan en tu VPC sino que usan un conector situado en la VPC para acceder a los servicios internos de esta). Por lo tanto, como los 2 servicios de Cloud Run no se encuentran en la VPC, con el conector si que pueden acceder a la base de datos, pero no se pueden comunicar entre ellos directamente. La solución es activar esta flag en aquellas subredes que los alojan(en este caso el conector).

Por último, ahora el módulo `services` añade dos nuevos permisos: `vpcaccess.googleapis.com`, `secretmanager.googleapis.com`.

## Recursos
https://cloud.google.com/run/docs/securing/managing-access?hl=es-419&_gl=1*1boj2ob*_ga*MTIyNTUxODc2Mi4xNjc4MTg5NzM0*_ga_WH2QY8WWF5*MTY4NDQwNjE5Mi42MS4xLjE2ODQ0MDgwODUuMC4wLjA.&_ga=2.119670792.-1225518762.1678189734#terraform
https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images?hl=es-419
https://cloud.google.com/vpc/docs/serverless-vpc-access?hl=es-419
https://cloud.google.com/load-balancing/docs/negs/serverless-neg-concepts?hl=es-419

https://cloud.google.com/run/docs/securing/ingress?hl=es-419
https://cloud.google.com/load-balancing/docs/https/ext-http-lb-tf-module-examples?hl=es-419#with_a_backend

Solución comunicación entre Cloud Run:
https://www.googlecloudcommunity.com/gc/Serverless/Communication-from-Cloud-run-to-Cloud-run/m-p/494029
https://cloud.google.com/run/docs/securing/private-networking?hl=es-419#from-gcp-serverless
https://cloud.google.com/vpc/docs/configure-private-google-access?hl=es-419#config-pga