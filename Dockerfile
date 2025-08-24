FROM tomcat:9.0-jre17

# Elimina la aplicación por defecto de Tomcat (ROOT)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copia tu .war al Tomcat
COPY ./target/miapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
