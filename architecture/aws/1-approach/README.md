# 1 Acercamiento
En el anterior ejemplo, al no especificar ningún recurso sobre VPC, AWS utiliza unos por defectos.
En este nuevo nivel, crearemos nosotros mismos una VPC propia con su respectiva subnet donde serán desplegadas varias instancias de VM. 
Otro de los objetivos de este nivel es la división de nuestro proyecto en distintos módulos, de manera que cada elemento de nuestra arquitectura objetivo corresponda a un módulo. Así, se han desarrollado 2 módulos: VPC y EC2. 

## VPC
Este módulo usará los siguientes recursos
1. `aws_vpc`. Para crear una VPC.
2. `aws_subnet`. Para crear una *subnet*. En este caso, y como queremos que los EC2 desplegados en ella sean accesible desde Internet, se ha activado el argumento `map_public_ip_on_launch` en `true`, lo que la convierte en una ***subnet* pública**.
3. `aws_internet_gateway`. Para crear un Internet Gatewat, que será usado para redirigir el tráfico entrante hacia las máquinas de la *subnet* creada.
4. `aws_route_table`. Para crear una tabla de rutas. En este caso únicamente incluye una ruta que redirigirá todo el tráfico (`0.0.0.0`) a través del *Internet Gateway* recién creado.
5. `aws_route_table_association`. Para crear una asociación la tabla de rutas a la *subnet* creada.
### Inputs
* `cidr_block`. Bloque de direcciones IP asignadas a la nueva VPC creada.
* `public_subnets`. Lista de direcciones IP asignadas a cada subnet dentro de la nueva VPC.
### Outputs
* `vpc_id`. ID de la VPC recién creada.
* `public_subnets`. Lista de IDs de las *subnets* públicas recién creadas.