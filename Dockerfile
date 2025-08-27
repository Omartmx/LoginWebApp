# === ETAPA 1: BUILD ===
# Usa una imagen oficial de Maven con la implementación Eclipse Temurin de OpenJDK 17.
FROM maven:3.9.6-eclipse-temurin-17 AS build
# ... (el resto de tu Dockerfile es correcto)

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración de Maven (pom.xml) para descargar las dependencias
# Esto es más eficiente, ya que Docker puede cachear las capas de dependencias si el pom.xml no cambia.
COPY pom.xml .

# Descarga las dependencias del proyecto
RUN mvn dependency:go-offline

# Copia el código fuente de tu aplicación al contenedor
COPY src ./src

# Empaqueta la aplicación en un archivo .war
RUN mvn package

# === ETAPA 2: SERVICIO ===
# Usa una imagen oficial de Tomcat como servidor de aplicaciones.
# 'tomcat:9.0.86-jdk17-temurin' es una buena opción que ya incluye JDK 17.
FROM tomcat:9.0.86-jdk17-temurin

# Elimina la aplicación de ejemplo de Tomcat para no interferir con la tuya
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia el archivo .war que se generó en la etapa 'build'
# El alias 'build' se usa aquí para acceder a los archivos de la primera etapa.
# 'LoginWebApp.war' es el nombre de tu proyecto por defecto, asegúrate de que coincida.
# Lo copiamos a ROOT.war para que la aplicación esté disponible en la raíz del servidor (ej. http://tu-dominio/)
COPY --from=build /app/target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Expone el puerto por defecto de Tomcat
EXPOSE 8080

# Comando para iniciar el servidor Tomcat
CMD ["catalina.sh", "run"]