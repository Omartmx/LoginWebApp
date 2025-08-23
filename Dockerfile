FROM maven:3.8.6-openjdk-17 AS build

# Copiar TODO el código fuente
COPY . /app
WORKDIR /app

# Compilar el proyecto
RUN mvn clean compile

FROM tomcat:9.0-jre17

# Copiar SOLO los archivos compilados y web
COPY --from=build /app/web/ /usr/local/tomcat/webapps/ROOT/
COPY --from=build /app/target/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]