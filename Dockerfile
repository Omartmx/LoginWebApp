FROM tomcat:9.0.108-jre17

# Eliminar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copiar el WAR
COPY ./dist/LoginWebApp.war /usr/local/tomcat/webapps/ROOT.war

# Dar tiempo para que Tomcat despliegue (30 segundos)
RUN sleep 30

# Verificar que se desplegó
RUN ls -la /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]