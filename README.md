# tfg-repo

## Architecture
Este directorio contiene la creación de una arquitectura de microservicios a través de distintos niveles en tres entornos _Cloud_, AWS, Azure y GCP. Para ello se hace uso de una herramienta de IaC como es Terraform, al igual que se utiliza Packer para un despliegue de microservicios en el acercamiento 3.
El README de cada nivel puede contener información desactualizada. Referirse siempre a su documentación propia en el TFG para conocer con detalle su funcionamiento.

## Micro-code
Contiene la creación de dos microservicios básicos con Spring Boot en Java, así como su Dockerfile para crear una imágen que será desplegada en el último nivel de la arquitectura previamente mencionada. Dichos servicios no son demasiado complejos pues su única finalidad es comprobar el correcto funcionamientro de las comunicaciones usuario-servicio, servicio-servicio y servicio-base de datos dentro de la arquitectura.