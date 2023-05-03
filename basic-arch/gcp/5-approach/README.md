# 5 Acercamiento
Para este último nivel se ha eliminado eliminado la conectividad con el exterior para las instancias del MIG. En su defecto, se ha incluido un nodo *jumpbox* para seguir permitiendo su acceso mediante SSH pero únicamente a través de esta máquina virtual, que estará representada mediante un nuevo módulo `jumpbox`.

## `JUMPBOX`
Define los siguientes recursos:
* `google_compute_instance`. Crea la máquina virtual que será usada como nodo *jumpbox*.

### Inputs
* `VPC`. VPC donde se creará el nodo *jumpbox*.
* `subnetwork`.  Subnet donde se creará el nodo *jumpbox*.

### `Outputs`
* `jumpbox_address`. Dirección IP pública de nodo *jumpbox*.

## Cambios en otros módulos
Ahora el `google_compute_instance_template` del módulo `MIG` define una plantilla sin IP públicas, de modo que sus instancias no sean accesible directamente desde el exterior. Para ello se ha eliminado el  bloque `access_config`.
## Recursos
https://cloud.google.com/compute/docs/instances/connecting-advanced?hl=es-419#windows
https://cloud.google.com/compute/docs/connect/ssh-using-bastion-host?hl=es-419
