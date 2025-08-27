# Usa una imagen base con Java y Maven
FROM maven:3.8.7-openjdk-17 AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración de Maven para descargar dependencias primero
COPY pom.xml .

# Descarga las dependencias
RUN mvn dependency:go-offline

# Copia el código fuente
COPY src ./src

# Empaqueta la aplicación en un archivo .war
RUN mvn package

# Segunda etapa: Usar una imagen de Tomcat para servir la aplicación
FROM tomcat:9.0.86-jdk17-temurin

# Elimina la aplicación de ejemplo de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia el archivo .war generado en la etapa 'build' al directorio de despliegue de Tomcat
# "LoginWebApp" debe ser el nombre de tu proyecto (definido en el pom.xml)
COPY --from=build /app/target/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Expone el puerto por defecto de Tomcat
EXPOSE 8080

# Comando para iniciar Tomcat
CMD ["catalina.sh", "run"]