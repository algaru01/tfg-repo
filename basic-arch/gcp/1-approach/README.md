# 1 Acercamiento
En este primer acercamiento vamos a crear una instancia de máquina virtual de Google Cloud. 
En primer lugar, en este Cloud cada vez que se va a hacer uso de un servicio o API en cada proyecto hay que activarlo, puesto que automáticamente están desactivados. Esto puede hacerse manualmente desde su interfaz web o a través del recurso 'google_project_service'. Es por ello que primeramente he creado un módulo 'services' para activar todos los servicios que se irán requiriendo a lo largo de este proyecto. Por ahora únicamente requeriremos de los servicios de 'compute'.

Para ello, se ha creado un módulo que se hace uso del recurso 'google_compute_instance' para crear una máquina virtual que requiere necesariamente:
 * Un tipo de instancia que establece la capacidad de la máquina, como el número de CPUs virtuales, la memoria, etc. Es posible acceder a los tipos disponibles mediante el CLI de GCP con 'gcloud compute machine-types list' o desde su interfaz web.
 * Un disco de arranque que contiene la imagen sobre la que correrá la máquina virtual con el sistema operativo y algún *software* preconfigurado.
 * Una interfaz de red para añadir la máquina virtual a una red, en este caso será la creada por defecto por Google Cloud. Automáticamente GCP añadeuna IP pública efímera a esta máquina virtual.
Además, se ha incluido un script que será ejecutado al lanzar la MV para lanzar un servidor web en un puerto seleccionado, y también una clave SSH para poder conectarse a esta instancia con el usuario 'ubuntu'.

Como se comentó, por defecto GCP hace uso de una red virtual por defecto, esta red tiene ciertas reglas de sefuridad (firewall) añadidas como permitir el acceso al puerto 22(SSH); sin embargo, es necesario añadir una regla adicional para permitir el tráfico desde Internet hacia el puerto donde se lanzará el servidor.


