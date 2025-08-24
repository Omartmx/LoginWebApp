FROM tomcat:9.0.108-jre17

# Copiar directamente la carpeta web/ descomprimida
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]