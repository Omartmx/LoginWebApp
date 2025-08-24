FROM tomcat:9.0-jre17

# Copiar recursos web
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Copiar clases compiladas
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]
