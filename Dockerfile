FROM maven:3.9.6-eclipse-temurin-17 AS build

COPY . /app
WORKDIR /app

# Compilar y verificar
RUN mvn clean compile
RUN echo "=== CLASES COMPILADAS ===" && \
    find /app/target/classes -name "*.class" | head -10

FROM tomcat:9.0.108-jre17

# Copiar web files
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Copiar clases y verificar
COPY --from=build /app/target/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
RUN echo "=== ESTRUCTURA FINAL ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ && \
    echo "=== CLASSES ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "No classes folder"

EXPOSE 8080
CMD ["catalina.sh", "run"]