# 4 Acercamiento
En este apartado se inlcuirá una base de datos al diseño. Para ello, se ha desarrollado un nuevo módulo llamado 'db' que creará un RDS de postgres con una base de datos 'student' y un usuario y contraseña que será pasado al crear el recurso.
Por seguridad, se ha situado esta base de datos en una subnet privada de modo que quedará aislada del tráfico fuera de su VPC y solo podrá ser accedida por las instancias de EC2 que definimos antes en la subnet pública. Además, en su grupo de seguridad se ha definido que únicamente aceptará tráfico en el puerto donde recibe peticiones la base de datos.
Para aumentar la disponibilidad, se ha incluido la opción de multi Availability Zone, que permite que Amazon aprovisione automáticamente y mantenga una o más instancias de base de datos secundarias en espera en una zona de disponibilidad diferente a la principal

Además, para este nuevo nivel se ha desarrollado un código que haga uso de la base de datos (por defecto tendrá 2 estudiatnes) con los siguientes endpoints:
    * GET /api/v1/student/ devolverá la lista de estudiantes en la base de datos.
    * POST /api/v1/student/ permitirá añadir un estudiante a la base de datos.
    * DELETE /api/v1/student/{studentID} borrará el estudiante con dicho ID.
    * PUT /api/v1/student/{studentID} permitirá modificar datos de dicho estudiante.
    * GET /api/v1/student/hello devolverá un hola mundo.

Para desplegar este código en las instancias de EC2 se ha hecho uso de una herramienta llamada 'Packer' de creación de plantillas de servidor. Esta herramienta de los mismos desarrolladores de Terraform, usa también HCL y te permite crear las imágenes que correrán en las máquinas virtuales, en este caso las AMI.