# 1 Acercamiento
En este primer acercamiento vamos a crear una instancia de máquina virtual de Google Cloud. Para ellos se hace uso del recurso 'google_compute_instance' que requiere necesariamente:
 * Un tipo de instancia que establece la capacidad de la máquina, como el número de CPUs virtuales, la memoria, etc. Es posible acceder a los tipos disponibles mediante el CLI de GCP con 'gcloud compute machine-types list' o desde su interfaz web.
 * Un disco de arranque que contiene la imagen sobre la que correrá la máquina virtual con el sistema operativo y algún *software* preconfigurado.
 * Una interfaz de red para añadir la máquina virtual a una red, en este caso será la creada por defecto por Google Cloud.
