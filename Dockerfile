FROM maven:3.9.6-eclipse-temurin-17 AS build

# Copiar TODO el proyecto
COPY . /app
WORKDIR /app

# Compilar las clases
RUN mvn clean compile

FROM tomcat:9.0.108-jre17

# Copiar web files y las clases compiladas
COPY ./web/ /usr/local/tomcat/webapps/ROOT/
COPY --from=build /app/target/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]