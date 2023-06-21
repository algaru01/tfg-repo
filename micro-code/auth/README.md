# Authentication microservice
Este servicio de autonticación muy sencillo establece un filtro que únicamente permite el paso a ciertos endpoints si en la cabecera de dicha llamada le acompaña un Bearer Token válido.
En total establece los siguientes endpoints.
* POST `api/v1/auth/register`. Registra un usuario en la base de datos a partir de un `firstname`, un `lastname`, un `email` y un `password` y le asigna un token de duración limitada.
* POST `api/v1/auth/authenticate`. Autentica un `email` y `password` y le asigna un token.
* GET `api/v1/auth/checkToken`. Comprueba que el token incluido en la cabecera sea válido. (Pasa por el filtro)
* GET `api/v1/auth/hello`. Simplemente devuelve un hola mundo.