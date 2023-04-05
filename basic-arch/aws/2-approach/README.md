# 2 Acercamiento
En el anterior ejemplo AWS hacia uso de un conjunto de recursos por defecto con respecto a la VPC. En este nuevo nivel crearemos nosotros mismos la red VPC y su respectiva subnet donde se encuentra la instancia de EC2 que creamos. Además, empezaremos a utilizar la modularización que nos facilita Terraform incluyendo todos estos recursos en un mismo módulo.

Por lo tanto crearemos:
    * Una VPC con bloque de IPs de 10.0.0.0/16.
        * Una subnet pública con el bloque de IPs de 10.0.0.0/24. Este hará uso de un Internet Gateway para redirigir el tráfico a nuestra instancia de EC2 a través de una tabla de rutas.