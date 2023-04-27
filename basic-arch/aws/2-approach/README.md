# 2 Acercamiento
En el anterior ejemplo AWS hacia uso de un conjunto de recursos por defecto con respecto a la VPC. En este nuevo nivel crearemos nosotros mismos la red VPC y su respectiva subnet donde se encuentra la instancia de EC2 que creamos. Además, empezaremos a utilizar la modularización que nos facilita Terraform incluyendo todos estos recursos en un mismo módulo.

Por lo tanto, se han desarrollado 2 módulos:

* VPC.
    * Construye la VPC donde se encontrarán los recursos. En este caso con un bloque de IPs de 10.0.0.0/16
    * Crea X subnets públicas. En este caso una con bloque de 10.0.0.0/24.
    * Un Internet Gateway para redirigir el tráfico hacia cada instancia de EC2 a través de una tabla de rutas.

* EC2.
    * Construye X instancias de EC2 de la misma manera que se hacia anteriormente pero esta vez dentro de una subnet pública especificada.