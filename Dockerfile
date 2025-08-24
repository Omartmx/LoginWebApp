FROM tomcat:9.0.108-jre17

# Eliminar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Crear directorio y descomprimir WAR manualmente
RUN mkdir -p /usr/local/tomcat/webapps/ROOT
COPY ./dist/LoginWebApp.war /tmp/
RUN unzip /tmp/LoginWebApp.war -d /usr/local/tomcat/webapps/ROOT/
RUN rm /tmp/LoginWebApp.war

EXPOSE 8080
CMD ["catalina.sh", "run"]