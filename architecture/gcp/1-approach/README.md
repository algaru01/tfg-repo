# 1 Acercamiento
En el anterior punto se hacia uso de una VPC por defecto proporcionada por GCP. Esto puede servir para diseños muy rápidos, pero lo normal es crear una propia para tener un mejor control de la misma. Es por ello que se ha desarrollado un nuevo módulo llamado `VPC` que creará la red virtual que contendrá todos los recursos de este proyecto. 

## `VPC`
Contiene los siguientes recursos:
* `google_compute_network`. Crea la VPC. A diferencia de otros entornos Cloud como AWS o Azure, en este caso no se especifica el bloque de direcciones que usará dicha red virtual, sino que serán sus propias subnets las que definirán esto.
* `google_compute_subnetwork`. Crea una *subnet* dentro de la VPC dentro de un rango de direcciones IP especificado a través de `ip_cidr_range`.
* Un módulo `FIREWALL` que contiene todas los `google_compute_firewall` asociadas a esta VPC y que se recomienda añadir desde la documentación de GCP.
	* Permitir el tráfico al servidor web.
	* Permitir tráfico SSH.
	* Permitir tráfico ICMP
	* Permitir tráfico interno
### Inputs
* `server_port`. Puerto donde se lanzará el servidor web.
* `public_subnets`. Lista de bloques IPs para cada subnet.
### Outputs
* `public_subnets`. Lista de IDs de las *subnets* creadas.

## Cambios en otros módulos
El módulo `VM` ahora acepta dos nuevos `inputs`:
* `subnet`. *Subnet* donde se desplegarán las VMs.
* `number_vms`. Número de VMs a ser creadas.

## Referencias
https://cloud.google.com/vpc/docs/subnets?hl=es-419
https://cloud.google.com/vpc/docs/firewalls?hl=es-419#more_rules_default_vpc