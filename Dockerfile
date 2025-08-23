FROM tomcat:9.0-jre17

# Copiar SOLO la carpeta web/ (que debe incluir las clases compiladas)
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]