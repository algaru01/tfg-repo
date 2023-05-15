# 1 Acercamiento
En este primer acercamiento vamos a crear una instancia de máquina virtual de Google Cloud que lance un pequeño servidor web en el puerto 8080. Este estará en un módulo llamado `VM`.

En primer lugar, en este Cloud cada vez que se va a hacer uso de un servicio o API en cada proyecto hay que activarlo, puesto que automáticamente están desactivados. Esto puede hacerse manualmente desde su interfaz web o a través del recurso 'google_project_service'. Es por ello que primeramente he creado un módulo 'services' para activar todos los servicios que se irán requiriendo a lo largo de este proyecto. Por ahora únicamente requeriremos de los servicios de 'compute'.

Por defecto, GCP hace uso de una red virtual por defecto, esta red tiene ciertas reglas de seguridad (`google_compute_firewall`) añadidas como permitir el acceso al puerto 22(SSH); sin embargo, es necesario añadir una regla adicional para permitir el tráfico desde Internet hacia el puerto donde se lanzará el servidor.

## `VM`
Este contendrá un único recurso:
* `google_compute_instance`. Crea una máquina virtual con algunos de los siguientes argumentos:
	* `machine_type`.  Un tipo de instancia que establece la capacidad de la máquina, como el número de CPUs virtuales, la memoria, etc. Es posible acceder a los tipos disponibles mediante el CLI de GCP con 'gcloud compute machine-types list' o desde su interfaz web.
	* `boot_disk`. Un disco de arranque que contiene la imagen sobre la que correrá la máquina virtual con el sistema operativo y algún *software* preconfigurado.
	* `network_interface`. Una interfaz de red para añadir la máquina virtual a una red, en este caso será la creada por defecto por Google Cloud. En este apartado cabe mencionar que GCP no diferencia de *subnets* publicas ni privadas. Cualquier máquina virtual con el parámetro `access_config` será dotado de una IP pública.
	* `metadata_startup_script`. Script que se ejecutará al inicio.
	* `metadata`. Permite establecer ciertos parámetros. Por ejemplo en este caso la clave SSH.
### Inputs
* `server_port`. Puerto donde correrá el servidor web.
### Outputs
* `vm_address`. Dirección IP pública de la VM.

