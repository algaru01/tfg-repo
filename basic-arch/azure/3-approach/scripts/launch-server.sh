#!/bin/bash
touch /home/ubuntu/src/hola.txt
nohup java -jar /home/ubuntu/src/demo-1.0.0-SNAPSHOT.jar --spring.datasource.url=jdbc:postgresql://${db_address}:5432/student --spring.datasource.username=${db_user} --spring.datasource.password=${db_password} &