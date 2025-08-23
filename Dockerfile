FROM tomcat:9.0-jre17

# Copiar la carpeta web/ (que contiene tus JSPs y WEB-INF)
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Copiar las clases compiladas (usando true en lugar de echo con comillas)
COPY ./build/web/WEB-INF/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || true
COPY ./dist/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || true

# Copiar el código fuente
COPY ./src/ /tmp/src/ 2>/dev/null || true

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]