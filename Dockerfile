FROM maven:3.9.6-eclipse-temurin-17 AS build

COPY . /app
WORKDIR /app

# Compilar y VERIFICAR
RUN mvn clean compile
RUN echo "=== ¿SE COMPILARON CLASES? ===" && \
    find /app/target/classes -name "*.class" 2>/dev/null | head -5 || echo "NO hay clases compiladas"

FROM tomcat:9.0.108-jre17

# Verificar estructura ANTES de copiar
RUN echo "=== ESTRUCTURA INICIAL TOMCAT ===" && \
    ls -la /usr/local/tomcat/webapps/

# Copiar web files
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Verificar si se copió web/
RUN echo "=== ¿SE COPIÓ web/? ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ 2>/dev/null || echo "NO se copió web/"

# Copiar clases compiladas (si existen)
COPY --from=build /app/target/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "No hay clases para copiar"

# Verificar estructura FINAL
RUN echo "=== ESTRUCTURA FINAL ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/ && \
    echo "=== WEB-INF ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/ 2>/dev/null || echo "No hay WEB-INF" && \
    echo "=== CLASSES ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || echo "No hay classes"

EXPOSE 8080
CMD ["catalina.sh", "run"]