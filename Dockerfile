FROM tomcat:9.0-jre17

# Copiar solo lo esencial - la carpeta web/
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Las clases se copiarán manualmente o se compilarán después
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]


