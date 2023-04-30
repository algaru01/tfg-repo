# 4 Acercamiento
En este útimo nivel, vamos a aumentar la seguridad de nuestro grupo de escalado cambiando su subnet pública por una privada y permitiendo su conexión SSH únicamente a través de un nodo bastión.

Para ello se han diseñados 2 nuevas redes:
* Una red bastion que es pública y con las reglas de seguridad que se especifican en la web de azure. A modo de resumen, el establcemiento de conexión ssh con el bastion no se hace directamente mediante SSH sino sobre HTTP, usando la API que proporciona Azure.
* Una red privada donde situábamos el set de escalado y que únicamente acepta conexiones SSH desde la red del nodo bastion.

## Referencias
https://learn.microsoft.com/en-us/azure/bastion/bastion-nsg