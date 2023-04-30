#!/bin/bash

sudo echo "hola" >> /home/ubuntu/prueba.txt

cat > index.html <<EOF
<h1>Hello, World</h1>
EOF

nohup busybox httpd -f -p ${server_port} &