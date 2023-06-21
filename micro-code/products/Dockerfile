# syntax=docker/dockerfile:1

FROM openjdk:17-oracle

ARG name="products"

ENV DATABASE_ADDRESS="my-rds-tfg.cojmznsixokq.eu-west-1.rds.amazonaws.com" 
ENV DATABASE_PORT="3306"
ENV DATABASE_USERNAME="usuario" 
ENV DATABASE_PASSWORD="password"

ENV AUTH_URL="tf-lb-20230526103935570100000006-1451359279.eu-west-1.elb.amazonaws.com" 

WORKDIR '/app'

COPY "code/target/products-1.0.0-SNAPSHOT.jar" .

CMD ["nohup", "java", "-jar", "products-1.0.0-SNAPSHOT.jar", "--spring.datasource.url=jdbc:postgresql://${DATABASE_ADDRESS}:${DATABASE_PORT}/student", "--spring.datasource.username=${DATABASE_USERNAME}", "--spring.datasource.password=${DATABASE_PASSWORD}", "--app.auth.url=${AUTH_URL}", "&"]

#CMD ["nohup", "java", "-jar", "products-1.0.0-SNAPSHOT.jar", "--spring.datasource.url=jdbc:postgresql://${DATABASE_ADDRESS}:${DATABASE_PORT}/student", "&"]
