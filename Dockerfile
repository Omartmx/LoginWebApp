FROM tomcat:9.0.108-jre17

# Copiar SOLO la carpeta web/ (debe tener las clases compiladas)
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]