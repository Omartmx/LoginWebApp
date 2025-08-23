FROM tomcat:9.0-jre17

# Copiar la carpeta web/ principal
COPY ./web/ /usr/local/tomcat/webapps/ROOT/

# Intentar copiar clases compiladas (si existen)
COPY ./build/web/WEB-INF/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || true
COPY ./dist/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/ 2>/dev/null || true

# Copiar código fuente por si acaso
COPY ./src/ /tmp/src/ 2>/dev/null || true

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
CMD ["catalina.sh", "run"]