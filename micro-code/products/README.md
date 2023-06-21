# Products microservice
Este servicio gestiona una lista de productos que únicamente podrá ser accedida mediante previa obtención de un token del servicio de autenticación. Este micro, por lo tanto, llamará al endpoint de `checkToken` del servicio de autenticación para comprobar que el Bearer Token incluido en la cabecera es válido.
En total establece los siguientes endpoints.
* POST `/api/v1/product/`. Crea un alumno con un `name`, `price`, `brand` en la base de datos.
* GET `/api/v1/product/`. Devuelve la lista de alumnos en la base de datos.
* PUT `/api/v1/product/<id_product>` Cambia algún valor de un estudiante a través de sus argumentos.
* DELETE `/api/v1/student/<id_product>`. Elimina un estudiante.