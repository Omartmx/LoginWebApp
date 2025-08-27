# === ETAPA 1: COMPILACIÓN ===
# Usa una imagen oficial de Maven con un JDK.
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copia los archivos de Maven para descargar las dependencias
COPY pom.xml .

# Descarga las dependencias
RUN mvn dependency:go-offline

# Copia todo el código fuente del proyecto
COPY src ./src

# Compila la aplicación y empaquétala en un archivo .war
RUN mvn clean package

# Comando de depuración para verificar si el .war se generó
RUN echo "=== VERIFICANDO EL ARCHIVO .WAR GENERADO ===" && \
    ls -la /app/target/

# === ETAPA 2: SERVICIO ===
# Usa la imagen oficial de Tomcat con JRE 17 para el servidor
FROM tomcat:9.0.86-jre17

# Elimina la aplicación de ejemplo que viene con Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# Copia el archivo .war desde la etapa de compilación
# El nombre 'LoginWebApp.war' debe coincidir con el <finalName> de tu pom.xml
COPY --from=build /app/target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Comando de depuración para verificar que el .war se copió a Tomcat
RUN echo "=== VERIFICANDO EL DESPLIEGUE EN TOMCAT ===" && \
    ls -la /usr/local/tomcat/webapps/

# Expone el puerto por defecto de Tomcat
EXPOSE 8080

# Comando para iniciar el servidor
CMD ["catalina.sh", "run"]