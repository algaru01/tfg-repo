# 3 Acercamiento
En el apartado anterior haciamos uso de una única instancia de EC2 que era accedida directamente a través de su IP pública. Esto puede traer varios problemas:
    * Poca disponibilidad. En caso de que la instancia falle, el servicio web deja de estar disponible.
    * Poca Seguirdad. Es poco seguro que el servidor sea accedido directamente desde Internet

En este nuevo acercamiento, crearemos 2 nuevos elementos organizados en 2 modulos distintos:
    * Un Grupo de Escalado que creará una serie de instancias de EC2 comprendidas en una horquilla   descrita, de manera que siempre haya un minimo de instancias disponibles. Es por ello que se ha añadido una segunda subnet en otra zona de disponibilidad de la región, de manera que aumente la disponibilidad de nuestro servicio.
    Además, debemos crear una plantilla de lanzamiento con, entre otras cosas, la imagen y el tipo de instancias que queremos que este Grupo de Escalado cree.

    * Un Balanceador de Carga que será el punto de acceso directo a al servicio y que se encargará de distribuir equitativamente las peticiones entre las distintas instancias del grupo de escalado. Como todos los recursos dentro de una VPC, necesitan tener un grupo de seguirdad que filtre el tráfico. En este caso permitimos todo el tráfico HTTP de entrada y todo de salida.
    Además, un balanceador de carga esta formado por 3 recursos:
        * Listener. Será el encargado de escuchar las peticiones en el puerto que nosotros hayamos decidido. En este caso, al trabajar con un servidor web escuchará en el puerto 80 (HTTP).
        * Listener Rules. Recibe las peticiones que ha aceptado el Listener y dependiendo la ruta que sigan estas peticiones, las envia a un Target Group u otro. En este caso simplemente haremos forwarding de todas las rutas
        * Target Group. Son uno o más servidores que recibirán las peticiones que ha filtrado el Load Balancer, en este caso nuestro Balanceador de Carga. Además, este recurso puede realizar comprobaciones periódicas sobre el estado de dichas máquinas. Por ejemplo, comprobar cada 15 segundos que la ruta "/" devuelve un código 200.

