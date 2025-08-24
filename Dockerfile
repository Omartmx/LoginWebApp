FROM maven:3.9.6-eclipse-temurin-17 AS build

COPY . /app
WORKDIR /app

# Compilar y VERIFICAR
RUN mvn clean compile
RUN echo "=== CLASES COMPILADAS? ===" && \
    find /app/target/classes -name "*.class" 2>/dev/null | head -5 || echo "NO_hay_clases_compiladas"

FROM tomcat:9.0.108-jre17

# Verificar estructura ANTES de copiar
RUN echo "=== ESTRUCTURA INICIAL TOMCAT ===" && \
    ls -la /usr/local/tomcat/webapps/

# Copiar web files
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Verificar si se copió web/
RUN echo "=== SE COPIO web/? ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ 2>/dev/null || echo "NO_se_copio_web"

# Copiar clases compiladas (si existen)
COPY --from=build /app/target/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || true

# Verificar estructura FINAL
RUN echo "=== ESTRUCTURA FINAL ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ && \
    echo "=== WEB-INF ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/ 2>/dev/null || echo "No_hay_WEB-INF" && \
    echo "=== CLASSES ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "No_hay_classes"

EXPOSE 8080
CMD ["catalina.sh", "run"]