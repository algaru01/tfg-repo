# 2 Acercamiento
En este nuevo nivel mejoraremos la seguridad y la disponibilidad de nuestro servicio con el uso de un set de escalado y un balanceador de carga.

* El set de escalado permitirá aumentar la disponibilidad de nuestro servicio al crear varias instancias
de máquinas virtuales con una misma configuración. En este caso lanzaremos 2 Ubuntu 18.04. A modo de mejora, es posible añadir otro recurso que monitorice este recurso para escalarlo mejor.

* En Azure, un balanceador de carga está formado por las siguientes partes:
    * Frontend IP Configuration. Contiene la dirección IP pública para que pueda ser accedido desde Internet.
    * Backend Pool. Son los grupos de recursos que recibirán el tráfico del balanceador de carga. En este caso el set de escalado.
    * Health Probe. Se utiliza para verificar el estado de los recursos del Backend Pool. En este caso comprobará el puerto donde corre nuestro servidor.
    * Load Balancer Rules. Reglas sobre como distribuir el tráfico entre los recursos del Backend Pool. En este caso reenviará todo el tráfico entrante al puerto del servidor al mismo puerto de una instancia del grupo de escalado.