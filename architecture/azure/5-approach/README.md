# 5 Acercamiento
En este nuevo nivel se susitituirán las máquinas virtuales por contenedores del servicio Azure Containers App. Este servicio te permite correr contenedores sin tener que preocuparte por gestionar el servidor donde correrán. Admás se ha añadido un nuevo microservicio de autenticación.
Para ello se han desarrollado dos nuevos módulos que sistuituirán al previo `SS`.

Antes de lanzar el módulo `ACA`, es necesario subir la imagen al contenedor de `ECR`:
    1. Primero deberemos hacer login con: az acr login --name <registry-name>.
    2. Etiquetamos la imagen con: docker tag <image_name> <registry-login-server>/<desired_image_name>:<tag>
    Como docker tag java-docker tfgcontainerregistry.azurecr.io/java-app:latest
    3. Pusheamos la imagen con: docker push <docker_tag>
    Como docker push tfgcontainerregistry.azurecr.io/java-app:latest

## `ACR`
Este módulo crea un Azure Container Repository que contendrá la imágen con el código a desplegar en cada contenedor. Para ello únicamente es necesario un recurso:
* `azurerm_container_registry`. Creará dicho repositorio dependiendo del nivel de SKU elegido. Además s eha activado el `admin_enabled` para poder acceder a dicho repositorio a través de un usuario y contraseña autogenerados.

Cabe recalcar que en este caso se hace uso de la SKU más básica porque es la más barata. SKUs más caras te ofrecen más opciones como convertir el repositorio en uno privado.
### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se encontrará el Azure Container Repository.
* `location`. Localización de dicho recurso.

### Outputs
* `username`. Usuario para acceder a este ACR.
* `password`. Contraseña para acceder a este ACR.
* `login_server`. Servidor al que hacer _login_.

## `ACA`
Este módulo crea un Azure Container Apps que lanzará un contenedor con una imagen que obtendrá del anterior módulo. Esta formado por los siguientes recursos:
* `azurerm_log_analytics_workspace`. Crea un recurso de monitorización para los contenedores de un mismo entorno.
* `azurerm_container_app_environment`. Crea un entorno donde se desplegarán todos los contenedores.
* `azurerm_container_app`. Crea un contenedor dentro de un `azurerm_container_app_environment`. Este contenedor contendrá una serie de _secretos_ con información sensibles como contraseñas; configurará una conexión con el `ACR` a través del bloque `registry`; crea una plantilla de despliegue del contenedor, donde se selecciona la imagen, la potencia y las variables de entorno a usar; y finalmente se configura un bloque `ingress` que determina el _frontend_ del contenedor, en este caso aceptará conexiones `http` al puerto 8080 y al 8081, según el caso.
Por último, `revision_mode` indica si puede haber más de una revisión a la vez, en este caso no.

### Inputs
* `resource_group_name`. Nombre del grupo de recursos donde se encontrará el Azure Container App.
* `location`. Localización de dicho recurso.
* `subnet`. Subnet donde se desplegará dicho recurso.
* `acr_username`. Nombre de usuario del ACR.
* `acr_password`. Contraseña del usuario del ACR.
* `acr_login_server`. Servidor de _login_ del ACR.
* `db_address`. Dirección de la base de datos.
* `db_port`. Puerto de la base de datos.
* `db_user`. Usuario de la base de datos.
* `db_password`. Contraseña de la base de datos.
* `X_ingress_target_port`. Puerto de entrada para el tráfico hacia el cotnenedor del micro X.

### Outputs
* `X_fqdn`. FDQN del contenedor X.
* `ip_address`. Dirección IP del entorno del contenedor.

## Cambios en otros módulos
En el módulo `AG` ahora se crean 2 _listeners_ que enrutan tráfico a través de 2 reglas de enrutamiento y 2 configuraciones HTTP a 2 backends distintos, uno por cada micro. Además, ahora `backend_address_pool` usa como _backend_ el `ip_address` del entorno del contenedor; de la misma forma que se hace uso del `fqdn` de cada contenedor para comprobar su estado.

## Referencias
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal?tabs=azure-cli
https://stackoverflow.com/questions/47424481/docker-push-to-azure-container-registry-access-denied