# 3 Acercamiento
En este nuevo acercamiento se sustituirá la máquina virtual por un grupo de instancias con autoescalado (MIG). Para ello se creará:
* Una plantilla a partir de la cual se crerán las máquinas virtuales. Aqui se define el tipo de máqiuina, la imágen de la máquina virtual, los scripts de inicio, etc...
* Un Autoescaler que contiene las politicas de escalado de la máquina, en este caso se deja por defecto que supere el umbral de 60% de uso de CPU.
* Un Health Check que comprobará periodicamente el estado del servidor de estas máquianas y hará que se reemplacen en caso de fallo.
* El grupo de instancias que usará todo lo definido previamente.

Además, se ha añadido un balanceador de cargas de red TCP/UDP externo. Este redistribuirá el tráfico entre las diferentes instancias que crea el instance manager. Para ello se utiliza el recurso 'google_compute_forwarding_rule' que recibirá el tráfico TCP entrante en una IP asignada y en un rango de puertos, en este caso podria ser 8080 (donde se lanza el servidor), y distribuirá el tráfico a un recurso 'google_compute_region_backend_service' que consistirá en el grupo de instancias que se creó anteriormente. 
Por último, se ha añadido un 'google_compute_region_health_check' que comproborá periódicamente el estado de estas máquinas de modo que el tráfico no se distribuya a aquellas que cumplen ciertas condiciones, en este caso por ejemplo aquellas máquinas donde el servicio esté caido. En este punto cabe descatacar que como se menciona en la documentación de Google, cada balanceador de carga y MIG deben de tener diferentes verificadores de estado, siendo el segundo más restrictivo que el primero, pues este hará que se cree una nueva máquina mientras que el primero solo determinará si el tráfico se dirigirá alli o no (https://cloud.google.com/compute/docs/instance-groups/autohealing-instances-in-migs?hl=es-419). En este caso, y debido a que el servicio es muy simple, ambos son iguales, pero habria que tener esto en cuenta en escencarios más complejos.


## Tips
Es necesario añadir ciertos permisos al servicio para que pueda obtener y ejecutar el script de inicialización.
En caso de que no se ejecute, puedes hacer uso del comando:
sudo journalctl -u google-startup-scripts.service
para ver un pequeño log de lo que ha pasado.
También puedes usar 
sudo google_metadata_script_runner startup
para re ejecutar el script.

Creo que el script no se encuentra en ningun lugar en local de la maquina, sino que hace uso de la API de Google para obtenerlo y ejecutarlo en remoto.

## Resources
https://cloud.google.com/load-balancing/docs/network?hl=es-419