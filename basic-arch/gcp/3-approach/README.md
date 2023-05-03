# 3 Acercamiento
En este nuevo acercamineto se sustituirá la máquina virtual por un grupo de instancias con autoescalado (MIG). Además, se añadirá un balanceador de cargas de red TCP/UDP externo que distribuirá el tráfico entre las diferencias instancias que se vayan creando.
Como se menciona en la documentación de GCP, ambos recursos deben de tener diferentes verificadores de estado, siendo el segundo más restrictivo que el primero, pues este hará que se cree una nueva máquina mientras que el primero solo determinará si el tráfico se dirigirá alli o no (https://cloud.google.com/compute/docs/instance-groups/autohealing-instances-in-migs?hl=es-419).

Por lo tanto, se han desarrollado dos módulos que representan cada uno de estos servicios.

## `MIG`
En este módulo se han creado los siguientes recursos:
* `google_compute_instance_template`. Crea una plantilla a partir de la cual se crerán las distintas instancias. Aquí se definen la mayoria de características que ya se definian al crear una simple VM como el `machine_type`, el `disk` con la imágen del sistema, la `network_insterface`, o el `metadata_startup_script`. Por último, cabe destacar que Google recomienda añadir ciertos permisos sobre `cloud-platform` para que todo funcione correctamente. Para ello se ha definido el bloque `service account` que da los permisos necesarios al email del servicio.
* `google_compute_instance_group_manager`.  Crea un grupo de instancias administrados. Entre sus argumentos encontramos:
	* `version`. Donde podemos definir el `google_compute_instance_template` que usará para crear las instancias.
	* `auto_healing_policies`. Para establecer algunas politicas sobre auto reparación. Para ello se ha definido un `google_compute_health_check` que se define a continuación.
* `google_compute_health_check`.  Comprueba periódicamente el estado del servidor de unas máquinas, y hará que se reemplacen en caso de fallo. Así, se definen varios argumentos como:
	* `check_interval_sec`. Para indicar la frecuencia con la que se realizarán las comprobaciones.
	* `timeout_sec`. Tiempo de espera hasta considerar un fallo.
	* `healthy_threshold`. El número de aciertos que debe de haber para considerar una máquina como en buen estado.
	* `unhealthy_threshold`. El número de fallos que debe de haber para considerar una máquina como en mal estado.
* `google_compute_autoscaler`. Permite escalar automáticamente un MIG según la política definida. Esto se define con `autoscaling_policy` dónde puedes definir ciertas métricas, aunque en este caso se deja la de por defecto que es un uso de la CPU por enicma del 60%.
* `google_service_account`. Define el email del servicio.

### Inputs
* `server_port`. Puerto donde correrá el servidor.
* `subnet`. *Subnet* donde se encontrará este MIG.
* `service_email`. Email de el servicio.
### Outputs
* `instance_group`. Grupo de instancias creadas. que será usado por el LB para distribuirle el tráfico.

## `LB`
Define los siguientes recursos:
* `google_compute_address`. Dirección IP que usará este Load Balancer.
* `google_compute_forwarding_rule`. Recibe el tráfico TCP entrante en una IP asignada y en un rango de puertos.
* `google_compute_region_backend_service`. Consiste en un grupo de isntancias a dónde distribuirá el tráfico el Load Balancer. Aquí se define el tipo de Load Balancer con `load_balancing_scheme` (en este caso externo) y el *backend* al que distribuirá el tráfico, así como el puerto y protocolo aque usará para comunicarse con él.
* `google_compute_region_health_check`. Comprueba periódicamente el estado de un *backend*, de modo que el tráfico no se distribuya a aquellas que cumplan ciertas condiciones.
### Inputs
* `check_port`. Puerto que se comprobará para comprobar el estado del *backend*.
* `instance_group_backend`. 

### Outputs
* `lb_address`. Dirección IP pública del Load Balancer.

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