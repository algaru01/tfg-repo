# 3 Acercamiento
En este nuevo acercamiento se sustituirá la máquina virtual por un grupo de instancias con autoescalado.


## Tips
Es necesario añadir ciertos permisos al servicio para que pueda obtener y ejecutar el script de inicialización.
En caso de que no se ejecute, puedes hacer uso del comando:
sudo journalctl -u google-startup-scripts.service
para ver un pequeño log de lo que ha pasado.
También puedes usar 
sudo google_metadata_script_runner startup
para re ejecutar el script.

Creo que el script no se encuentra en ningun lugar en local de la maquina, sino que hace uso de la API de Google para obtenerlo y ejecutarlo en remoto.