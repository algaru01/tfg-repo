# Acercamiento 0
Este acercamiento baásico usará las redes virtuales que AWS crea por defecto.
Usaremos únicamente una instancia de EC2, que corresponde con el recurso `aws_instance` y un grupo de seguirdad para permitir el tráfico `HTTP` a dicho máquina (`aws_security_group`). 

El primero requiere obligatoriamente de dos parámetros:
* `ami`
* `instance_type`
Y para obtener dichos datos hemos hecho uso de `aws_ami` y `aws_ec2_instance_types` respectivamente, que buscarán una imágen 20.04 de Ubuntu y un tipo de instancia gratuita.
Además, se ha hecho uso del argumento `user_data` para desplegar en dicho EC2 un servidor web secillo en el puerto 8080, que mostrará un `Hello, World`. 

Por último, el grupo de seguridad contiene únicamente uns regla que permite el ingreso de cualquier tráfico `TCP` hacia el puerto donde hemos desplegado el servidor web.