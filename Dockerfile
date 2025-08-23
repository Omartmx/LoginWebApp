FROM maven:3.8.6-openjdk-17 AS build

# Copiar TODO el proyecto
COPY . /app
WORKDIR /app

# Compilar el proyecto
RUN mvn clean package

FROM tomcat:9.0-jre17

# Copiar el WAR generado
COPY --from=build /app/target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]