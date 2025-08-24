FROM maven:3.9.6-eclipse-temurin-17 AS build

# Copiar TODO el proyecto
COPY . /app
WORKDIR /app

# Compilar y generar WAR
RUN mvn clean package

FROM tomcat:9.0.108-jre17

# Descomprimir el WAR generado
RUN mkdir -p /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/LoginWebApp.war /tmp/
RUN unzip /tmp/LoginWebApp.war -d /usr/local/tomcat/webapps/ROOT/
RUN rm /tmp/LoginWebApp.war

EXPOSE 8080
CMD ["catalina.sh", "run"]