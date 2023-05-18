# syntax=docker/dockerfile:1

FROM openjdk:17-oracle

ENV DATABASE_ADDRESS="my-rds-tfg.cojmznsixokq.eu-west-1.rds.amazonaws.com" 
ENV DATABASE_PORT="3306"
ENV DATABASE_USERNAME="usuario" 
ENV DATABASE_PASSWORD="password"

WORKDIR '/app'

COPY "demo-1.0.0-SNAPSHOT.jar" .

CMD ["nohup", "java", "-jar", "demo-1.0.0-SNAPSHOT.jar", "--spring.datasource.url=jdbc:postgresql://${DATABASE_ADDRESS}:${DATABASE_PORT}/student", "--spring.datasource.username=${DATABASE_USERNAME}", "--spring.datasource.password=${DATABASE_PASSWORD}", "&"]

