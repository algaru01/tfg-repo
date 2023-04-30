# 2 Acercamiento
En el anterior punto se hacia uso de una VPC por defecto proporcionada por GCP. Esto puede servir para diseños muy rápidos, pero lo normal es crear una propia para tener un mejor control de la misma.

Es por ello que se ha desarrollado un nuevo módulo llamado 'vpc' que creará la red virtual que contendrá todos los recursos de este proyecto. A diferencia de otros entornos Cloud como AWS o Azure, en este caso no se especifica el bloque de direcciones que usará dicha red virtual, sino que serán sus propias subnets las que definirán esto.

En este ejemplo se ha incluido también la opción de crear diferentes subnets públicas sobre las que montar distintas máquinas virtuales, además se han construido ciertos firewalls para limitar el tráfico de la red:
* Se permitirá el tráfico al puerto 22(SSH)
* Se permitirá el tráfico al puerto donde se ha lanzado el servidor web.
* Se permitirá el tráfico ICMP.
* Se permitirá todo el tráfico interno dentro de la red.

## Referencias
https://cloud.google.com/vpc/docs/subnets?hl=es-419
https://cloud.google.com/vpc/docs/firewalls?hl=es-419#more_rules_default_vpc