FROM maven:3.9.6-eclipse-temurin-17 AS build

COPY . /app
WORKDIR /app

# Compilar solo
RUN mvn clean compile

FROM tomcat:9.0.108-jre17

# Copiar web files
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Copiar clases compiladas (si existen)
COPY --from=build /app/target/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

# Verificar estructura FINAL
RUN echo "=== ESTRUCTURA FINAL ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ && \
    echo "=== WEB-INF ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/ && \
    echo "=== CLASSES ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]