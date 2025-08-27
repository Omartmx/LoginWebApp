# === ETAPA 1: COMPILACIÓN ===
# Usa una imagen oficial de Maven con un JDK.
# El alias 'build' nos permite referenciar esta etapa más tarde.
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de Maven para descargar las dependencias
COPY pom.xml .

# Descarga las dependencias
RUN mvn dependency:go-offline

# Copia todo el código fuente del proyecto
COPY src ./src

# Compila la aplicación y empaquétala en un archivo .war
RUN mvn clean package

# === ETAPA 2: SERVICIO ===
# Usa la imagen oficial de Tomcat con JRE 17 para el servidor
FROM tomcat:9.0.86-jre17

# Elimina la aplicación de ejemplo que viene con Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia el archivo .war que se generó en la etapa de compilación
# El nombre 'LoginWebApp.war' viene del <finalName> en tu pom.xml
# Lo copiamos a ROOT.war para que la aplicación sea la página de inicio
COPY --from=build /app/target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Expone el puerto por defecto de Tomcat
EXPOSE 8080

# Comando para iniciar el servidor
CMD ["catalina.sh", "run"]

# Comandos de HEALTHCHECK y RUN para depuración (opcional, pero útil)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
 CMD curl -f http://localhost:8080/ || exit 1

RUN echo "=== VERIFICANDO DESPLIEGUE ===" && \
    ls -la /usr/local/tomcat/webapps/ROOT.war && \
    echo "=== LISTO ==="