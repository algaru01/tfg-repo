# 4 Acercamiento
En este cuarto acercamiento, moveremos el Grupo de Autoescalado a unas *subnets* privadas y limitaremos su conexión SSH a través de un nuevo nodo *jumpbox* que se encontrará en una *subnet* pública. Así, cualquiera que quiera acceder a las EC2 del ASG desde internet, deberá primeramente pasar el filtro que se establezca dentro del nodo jumpbox. El comando SSH para acceder será: 'ssh -J ubuntu@<jumpbox_ip> ubuntu@<vm_private_ip>', habiendo añadido previamente mediante 'ssh-add <private_key>' las claves de ambas máquinas.

De este modo creamos un nuevo módulo llamado `Jumpbox`.
##### Jumpbox
Este módulo consta de un simple `aws_instance` similar al que creamos en el primer acercamiento pero con un clave SSH  y un grupo de seguridad que únicamene permita el tráfico SSH.

###### Inputs
* `vpc_id`. ID de la VPC donde se desplegará el nodo *jumpbox*
* `jumpbox_subnet`. Subnet donde se desplegará el nodo *jumpbox*.

###### Outputs
* `jumpbox_address`. Dirección IP pública del nodo *jumpbox*.
##### Cambios en otros módulos
Ahora el el Grupo de Autoescalado del módulo `ASG` se encuentra en *subnets* privadas.