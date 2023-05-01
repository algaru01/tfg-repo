# 5 Acercamiento
Para este último nivel se ha eliminado eliminado la conectividad con el exterior para las instancias del MIG. Para ello se ha eliminado el bloque 'acces_config' de la interfaz de red que asignaban automáticamente una dirección IP pública a cada máquina virtual.

Para seguir permitiendo su acceso mediante SSH se ha añadido un nodo jumpbox que ha sido implementado mediante una instance de computación con IP pública y que se ha incluido dentro de una nueva subnet. 
## Recursos
https://cloud.google.com/compute/docs/instances/connecting-advanced?hl=es-419#windows
https://cloud.google.com/compute/docs/connect/ssh-using-bastion-host?hl=es-419
