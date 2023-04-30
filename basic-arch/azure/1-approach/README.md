# 1 Acercamiento
En este primer acercamiento se ha creado una única máquina virtual en Azure.

En Azure todos los recursos pertenecen a un grupo de recursos, que en este caso establecerá la localización de los mismos en "West Europe". Dentro de este grupo se ha creado:
* Una red virtual junto con una subnet pública.
* Una Máquina Virtual en dicha subnet con una imágen de Ubuntu 18.04 y que lanzará un pequeño servidor web en el puerto 8080.

En Azure no hay distinción entre subredes privada o públicas. Para gestionar esta característica es necesario crear un grupo de seguridad que limite el tráfico en cada una de estas subnets. Por ejemplo, para construir una subred privada, habria que asociarle un regla a su grupo de seguridad que no permita ningún tráfico entrante ni saliente de ningún tipo. En este caso, como queremos un servidor web accesible desde el exterior, permitimos el de SSH y al puerto del servidor. 

Además, será necesario adjuntar a la VM una interfaz de red con una IP pública accesible desde Internet. 