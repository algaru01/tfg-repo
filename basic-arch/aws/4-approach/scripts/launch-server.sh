#!/bin/bash
mkdir /home/ubuntu/prueba
nohup java -jar /home/ubuntu/src/demo-1.0.0-SNAPSHOT.jar --spring.datasource.url=jdbc:postgresql://${db_address}:3306/student --spring.datasource.username=${db_user} --spring.datasource.password=${db_password} &