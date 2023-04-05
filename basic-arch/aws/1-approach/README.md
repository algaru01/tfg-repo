# 1er Acercamiento

En este directorio haremos un primer acercamiento de arquitectura básica en AWS con únicamente una instancia de EC2 en AWS.

Para ello, recogeremos de AWS la información de la AMI de Ubuntu 20.04 de Canonical más reciente así como cualquiera de los tipos de instancia que ofrece gratuitamente AWS, y la usamos para crear la instancia.

Además desplegaremos un servidor web sencillo que mostrará un "Hello, World" en el puerto 8080. Para ello necesitamos saber la IP pública del servidor, por lo que la mostraremos con una variable output; y permitir el tráfico entrante a dicho puerto, por lo que necesitaremos crear un grupo de seguridad que permita el tráfico a esta instancia través de este puerto.