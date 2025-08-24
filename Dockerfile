
FROM tomcat:9.0-jre17

# Copiar JSPs, HTML, CSS
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Copiar las clases compiladas de NetBeans
COPY ./build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080
CMD ["catalina.sh", "run"]
